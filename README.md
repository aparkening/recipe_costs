# Recipe Costs

Professional kitchens need to know their recipe costs to profitably price their food. Recipe Costs makes it easy for chefs to figure out the cost-per-serving of their recipes.

**App Features**
- Users can log in directly or with their Google account.
- Authenticated users can create, read, update, and delete their own recipes and ingredients.
- Recipe costs are calculated per recipe and per serving.
- Ingredient conversions are automatic. Recipe amounts entered as cups will seamlessly take advantage of costs entered as liters or gallons, for example.
- App-wide ingredients and default costs provide faster recipe creation, and users can customize ingredient prices for their own recipes.
- Users can browse their full recipe list or recipes by ingredient.


## Basic Installation

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
5. Navigate to `localhost:3000` in your browser to begin using the app. 

Add your own data to get started, or add Google Sign In functionlity and/or bulk users, ingredients, and recipes below.

## Google Sign In Installation (Google Oauth)
To use Google accounts, you'll need to create your own Google API key and store the credentials inside a local file.

### Create Credentials File

1. Make a new `.env` file in the main directory. This file has been ignored by Git, so it will stay local.

2. Add the following placeholders to your `.env` file. Once you've created your id and secret, add them to the appropriate variable name below.
```
GOOGLE_CLIENT_ID=<replace me with ID>
GOOGLE_CLIENT_SECRET=<replace me with secret>
```

### Create Google Credentials

Note: Handy screenshot instructions are in the "Create Google App" section of https://medium.com/@amoschoo/google-oauth-for-ruby-on-rails-129ce7196f35. 


1. Navigate to https://console.developers.google.com/ and log in with a Google account.

2. Select '+' to create a new Google project. The project name can be anything you choose.

3. Select 'Credentials' and 'Oauth consent screen'. Input your own contact information. The app doesn't require terms or other URLs.

4. Create Oauth client ID and input the following URL in the 'Authorized redirect URIs' field: http://localhost:3000/auth/google_oauth2/callback

5. Add the resulting client id and secret to your `.env` file.

## Add Bulk Users, Ingredients, and Recipes

To interact with many users, ingredients, and recipes, add the seed data and CSV files below.

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

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aparkening/recipe_costs/blob/master/CODE_OF_CONDUCT.md).
