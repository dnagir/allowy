# Allowy - the simple authorization for Ruby (and/or Rails)

Allowy is the authorization library that doesn't enforce tight DSL on you.
It is very simple yet powerful.

## Why another one?

I've been using really great [cancan](https://github.com/ryanb/cancan) gem by Ryan Bates for a long time.
It does its job amazingly well.

Allowy is basically the result of refactoring the CanCan Ability class. I then extracted it into a gem.

CanCan doesn't work very well for me when Ability definitions grow above 20 lines or so:

- it becomes **really hard to track down** why something was (or not) allowed.
- **DSL enforces** you to use ActiveRecord-like scopes or blocks. It gets harder to maintain.
- The Ability class contains **all the definitions for everything**. Hard to test, hard to maintain unless carefully refactor it.
- Implicit permission - CanCan tries to be very smart (and is indeed) using aliases such as `:manage` but it makes even harder to maintain.
- Implicit permission - you can use any symbol to check permissions. `:love_people` will do, even if you never defined it.
- A little bit **tight to ORM**. When using with database such as neo4j, some smalish things don't work. So I prefer to be explicit.
- **Testing** an ability for a single class often depends on too many others.
- **Refacoring** of the abilities feels like rolling your own authorization library.

So I decided to put up allowy to solve those issue for me.

[Allowy](https://github.com/dnagir/allowy) better suites if you want more control over your authorization. It is inspired by CanCan, but was implemented with simplicity and explicitness in mind.


# Install

Add it to your Rails application's `Gemfile`:

```ruby
gem 'allowy'
```

Then `bundle install`.

Or use `allowy` gem any other way you are not in Rails.

# Usage

I will be assuming a CMS-like system in the examples below.
The `Page` class may be ActiveRecord, Mongoid or any other model of your choise. Doesn't matter.


## Minimal setup

You define a set of permissions per class.
If you want to safeguard `Page` class then define `PageAccess` class:

```ruby
class PageAccess
  include Allowy::AccessControl

  # This will allow you to ask: can? :view, page
  # The truthy result of this function will grant access, otherwise not.
  def view?(page)
    page and page.published?
  end

  def edit?(page)
    page and page.wiki?
  end
end

# Then, in rails, you would use it:
can? :view, page
cannot? :edit, page
authorize! :view, page # raises Allowy::AccessDenied if can?(:view, page) returns false
can? :love_people, page # Will raise error because `love_people` is not defined on the Access Control class
```

## Context

You can access current user, request data etc using the `context` method.
In Rails, the context is set to the current controller, so you have full access to it (not only the current user!).


```ruby
class PageAccess
  include Allowy::AccessControl

  def view?(page)
    return true if context.params[:hiddedn_hack_for_admin]
    context.user_signed_in? and page.published?
  end
end
```

If you want to change the context in Rails then just override it in the controller or globally in the `ApplicationController`:

```ruby
class PagesController < ApplicationController
  def allowy_context
    {realy: 'anything', can_be: 'here', even: params}
  end
end
```

## More comprehensive example

You probably have multiple classes that you want to protect.
I recommend creating your own base class to provide common context and maybe some utility methods:

```ruby
class DefaultAccess
  include Allowy::AccessControl
  delegate :current_user,    :to => :context
  delegate :current_company, :to => :context

  def domain_name
    context.request.host
  end
end
```

Then you can create multiple access control classes:

```ruby
class PageAccess < DefaultAccess
  # can? :view, page
  def view?(page)
    page and page.published? and domain_name =~ /^www\./i
  end

  # can? :edit, page
  def edit?(page)
    view?(page) and page.wiki? # Notice how we can reuse other definitions!
  end

  # can? :create, WikiPage
  def create?(page_class)
    # We can do something with WikiPage here if we need to
    return false if page_class.count >= 2 # only 2 wiki pages allowed
    # but can just ignore it and authorize based on current context only
    current_user and current_user.admin?
  end

  # can? :search, Page, 'Ruby rocks!'
  def search?(clazz, phrase)
    # Apart from context, we can require to pass additional parameters
    create?(Page) and (phrase || '').match /rocks/i
  end
end
```

In your controller:

```ruby
class PagesController < ApplicationController
  def show
    @page = Page.find(params[:id])
    authorize! :view, @page # It will raise if declined
    # can?, cannot? can be used too
  end

  # Add this to the ApplicationController to handle it globally
  rescue_from Allowy::AccessDenied do |exception|
    logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to new_user_session_url, :alert => exception.message
  end
end
```

In your views:

```haml
# app/views/pages/show.html.haml

%h1= @page.name
= link_to "Edit", edit_page_path if can? :edit, @page
```


# Testing with RSpec

To test the access control classes you can just instantiate those passing context as a parameter.
Most of the time you will stub out the context, so the test isolation is a piece of cake.

You need to `require 'allowy/rspec'`.
It will give you RSpec matcher `be_able_to` and `ignore_authorization!` macro for controller specs.


```ruby
# spec/models/page_access.rb
# Example spec for the PageAccess
describe PageAccess do
  subject     { PageAccess.new double(current_user: User.new.or_whatever) }
  let(:page)  { Page.new }

  describe "#view" do
    it { should_not be_able_to :view, page }

    # Or without the matcher
    it "should not allow" do
      subject.view?(page).should be_false
    end

    context "when published" do
      before { page.publish! }
      it { should be_able_to :view, page }
    end
  end

  # and so on
end


# Example of a controller specs
describe PagesController do
  # This will always grant access, so you don't have to create too many objects
  # But make sure you test PageAccess separately as in the example above
  ignore_authorization! 

  it "will always allow no matter what" do
    post(:create).should be_success
  end
end

```

But if you don't want to stub the context because you access its `can?`, `cannot?` or `authorize!` methods
(allwing permission delegation) then you can simply mix the `Allowy::Context` in:

```ruby
class ControllerLikeContext
  include Alllowy::Context
  attr_accessor :current_user

  def initialize(user)
    @current_user = user
  end
end

# Then you can simply instantiate it to check the permissions:
ControllerLikeContext.new(that_user).should be_able_to :edit, Blog
ControllerLikeContext.new(this_user).should_not be_able_to :edit, Blog
```


# Development


- Source hosted at [GitHub](https://github.com/dnagir/allowy)
- Report issues and feature requests to [GitHub Issues](https://github.com/dnagir/allowy/issues)
- Ping me on Twitter [@dnagir](https://twitter.com/#!/dnagir)


To start contributing (assuming you already cloned the repo in cd-d into it):

```bash
bundle install
# Now run the Ruby specs
bundle exec rspec spec/
```


Pull requests are very welcome, but please include the specs.

# License

[MIT] (http://www.opensource.org/licenses/mit-license.php)
