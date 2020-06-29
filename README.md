# Recipe Costs

Professional kitchens need to know their recipe costs to profitably price their food. Recipe Costs makes it easy for chefs to figure out the cost-per-serving of their recipes.

**App Features**
- Users can log in directly or with their Google account.
- Authenticated users can create, read, update, and delete their own recipes and ingredients.
- Recipe costs are calculated per recipe and per serving.
- Ingredient conversions are automatic. Recipe amounts entered as cups will seamlessly take advantage of costs entered as liters or gallons, for example.
- App-wide ingredients and default costs provide faster recipe creation, and users can customize ingredient prices for their own recipes.
- Users can browse their full recipe list or recipes by ingredient.


## Installation

1. Clone this repo.
2. Install dependences:
```
    $ bundle install
```
3. Create database structure:
```
    $ rails db:migrate
```
4. Run web server:
```
    $ rails s
```
5. Navigate to `localhost:3000` in your browser.

## Usage

Add your own data to get started. Or take the steps below to interact with a fully-populated app.

1. Run the seed file to create default users and starter ingredients:
```
    $ rails db:seed
```

2. Add larger ingredient list by importing included CSV file:

    1. Log in as the admin user, David Baker (with password `testing123`).
    2. Navigate to `/ingredients` and upload the `ingredients.csv` file from `app/assets`.
    3. Look at all that new ingredient data!

3. Add more recipes to each user by uploading their individual CSV files:

    1. Log in as any default user from `/db/seeds.rb`, such as Paul Hollywood, Mary Berry, and Peter Reinhart (all with passwords `testing123`).
    2. Navigate to `/recipes` and notice the recipes don't have ingredients or costs. Upload the CSV matching the user's name from `app/assets`.
    3. Each recipe now has costs and ingredient amounts!

## Development

In addition to the web interface, you can interact with the app via command line by using `rails c`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aparkening/recipe_costs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tea Tastes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aparkening/recipe_costs/blob/master/CODE_OF_CONDUCT.md).
