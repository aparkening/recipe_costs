# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_10_213134) do

  create_table "categories", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "category_recipes", force: :cascade do |t|
    t.integer "category_id"
    t.integer "recipe_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_category_recipes_on_category_id"
    t.index ["recipe_id"], name: "index_category_recipes_on_recipe_id"
  end

  create_table "flags", force: :cascade do |t|
    t.integer "user_id"
    t.integer "ingredient_id"
    t.string "type"
    t.string "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_flags_on_ingredient_id"
    t.index ["user_id"], name: "index_flags_on_user_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.float "cost"
    t.float "cost_size"
    t.string "cost_unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "ingredient_id"
    t.float "ingredient_amount"
    t.string "ingredient_unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.integer "servings"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
  end

  create_table "user_ingredient_costs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "ingredient_id"
    t.float "cost"
    t.float "cost_size"
    t.string "cost_unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_user_ingredient_costs_on_ingredient_id"
    t.index ["user_id"], name: "index_user_ingredient_costs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "role"
    t.string "organization"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "weight_volume_conversions", force: :cascade do |t|
    t.integer "ingredient_id"
    t.float "weight_size"
    t.string "weight_unit"
    t.float "vol_size"
    t.string "vol_unit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ingredient_id"], name: "index_weight_volume_conversions_on_ingredient_id"
  end

  add_foreign_key "category_recipes", "categories"
  add_foreign_key "category_recipes", "recipes"
  add_foreign_key "flags", "ingredients"
  add_foreign_key "flags", "users"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "user_ingredient_costs", "ingredients"
  add_foreign_key "user_ingredient_costs", "users"
  add_foreign_key "weight_volume_conversions", "ingredients"
end
