[![Build Status](https://travis-ci.org/westfieldlabs/sanitize_order.svg?branch=master)](https://travis-ci.org/westfieldlabs/sanitize_order)

# SanitizeOrder

Sanitize an SQL order clause that might be tainted. Includes a whitelist option to
limit the available columns to sort by and translate the given column names to
actual table_name.column_name pairs.

## Installation

Add this line to your application's Gemfile:

    gem 'sanitize_order'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sanitize_order

## Usage

In your model, add

    include SanitizeOrder

and in your controller safely set the order scope with

    #sanitize_order(tainted_order)
or

    #sanitize_order(tainted_order, whitelist)

where `tainted_order` is in the form of:

    column_name direction, column_name direction, ...

`direction` is optional and can be `ASC` or `DESC` and defaults to `ASC` if not
given. Case is ignored.

For example:

    country asc, start_date

A column name whitelist is used if given, otherwise columns are validated
directly against the table column names. `column_name` may be in the form:

    table_column_name

  or

    table_name.table_column_name

The whitelist is a hash of allowed input table columns and the matching actual
table and column names. For example:

    {
      'centre_id' => 'centre.id'
      'enabled_at' => 'centre.enabled_date'
      'disabled_at' => 'centre.disabled_date'
      'features' => 'centre_features.name'
    }

The whitelist is assumed clean and correct so no checking is done on its
contents.
