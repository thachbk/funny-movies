# frozen_string_literal: true

require 'rails_helper'
def rspec_swagger_description
  <<~MD
    ### How to setup rspec swagger
    1. Add `gem 'rswag-specs'` to Gemfile, in development and test group
    ```ruby
    group :development, :test do
      gem 'rspec-rails'
      gem 'rswag-specs'
    end
    ```

    2. Run the install generator
    ```ruby
    RAILS_ENV=test rails g rswag:specs:install
    ```

    3. Create an integration spec to describe and test your API. There is also a generator for this:
    ```ruby
    rails generate rspec:swagger API::MyController
    ```

    4. Generate the Swagger JSON file(s)
    ```ruby
    rake rswag:specs:swaggerize
    ```
    This will generate a Swagger JSON file for each of your specs, in the `swagger_root` folder that you specified in `config/initializers/rswag-api.rb`.

    5. Spin up your Rails server and visit the Swagger UI page at `/api-docs`. You should see a list of your Swagger JSON files, and you can browse them from there.

    ### How to write rspec swagger
    1. Add `swagger_doc` tag to the root example_group in your specs

  MD
end

def api_docs_description
  <<~MD
    ### How to get an API key
    Our API is currently in beta. If you would like to get an API key, please contact us at [support@mydomain.io](mailto:support@mydomain.io)

    ### Request Content-Type
    The Content-Type for POST and PUT requests should be set to `application/json`. This is a custom media type that is used to identify requests that follow the [JSON:API specification](https://jsonapi.org/).

    ### Authentication
    All endpoints require additional parameters, api version as well as the token, which is sent in the `X-API-VERSION` and `Authorization` header respectively.
  MD
end

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('api-docs').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1',
        description: api_docs_description,
        'x-logo': {
          url: 'https://example.com/logo.png'
        }
      },
      paths: {},
      components: {
        securitySchemes: {
          bearerAuth:  {
            type:   :http,
            scheme: :bearer
          },
          api_version: {
            type: :apiKey,
            name: 'X-API-VERSION',
            in:   :header
          }
        },
        responses:       {
          # 401
          unauthorized:          {
            description: 'Unauthorized',
            content:     {
              'application/json': {
                schema: {
                  '$ref' => '#/components/schemas/error'
                }
              }
            }
          },
          # 404
          not_found:             {
            description: 'Not Found',
            content:     {
              'application/json': {
                schema: {
                  '$ref' => '#/components/schemas/error'
                }
              }
            }
          },
          # 422
          unprocessable_entity:  {
            description: 'Unprocessable Entity',
            content:     {
              'application/json': {
                schema: {
                  '$ref' => '#/components/schemas/error'
                }
              }
            }
          },
          # 500
          internal_server_error: {
            description: 'Internal Server Error',
            content:     {
              'application/json': {
                schema: {
                  '$ref' => '#/components/schemas/error'
                }
              }
            }
          },
          # 400
          bad_request:           {
            description: 'Bad Request',
            content:     {
              'application/json': {
                schema: {
                  '$ref' => '#/components/schemas/error'
                }
              }
            }
          },
          # 405
          method_not_allowed:    {
            description: 'Method Not Allowed',
            content:     {
              'application/json': {
                schema: {
                  '$ref' => '#/components/schemas/error'
                }
              }
            }
          },
          # 403
          forbidden:             {
            description: 'Forbidden',
            content:     {
              'application/json': {
                schema: {
                  '$ref' => '#/components/schemas/error'
                }
              }
            }
          }
        },
        schemas:         {
          meta:                           {
            type:                 :object,
            properties:           {
              status:  { type: :string },
              message: { type: :string }
            },
            required:             %w[status message],
            example:              {
              status:  'success',
              message: 'success'
            },
            description:          'Meta response',
            additionalProperties: false
          },
          error:                          {
            type:                 :object,
            properties:           {
              status:     { type: :string },
              message:    { type: :string },
              errors:     { type: :array, nullable: true },
              error_code: { type: :string, nullable: true }
            },
            required:             %w[status message],
            example:              {
              status:  'fail',
              message: 'Bad Request'
            },
            description:          'Error response',
            additionalProperties: false
          },
          pagination:                     {
            type:                 :object,
            properties:           {
              current_page: { type: :integer },
              next_page:    { type: :integer },
              prev_page:    { type: :integer },
              total_pages:  { type: :integer },
              limit_value:  { type: :integer }
            },
            required:             %w[current_page next_page prev_page total_pages limit_value],
            example:              {
              current_page: 1,
              next_page:    2,
              prev_page:    nil,
              total_pages:  1,
              limit_value:  10
            },
            description:          'Pagination response',
            additionalProperties: false
          },
          success:                        {
            type:                 :object,
            properties:           {
              status:  { type: :string },
              message: { type: :string },
              data:    { type: :object }
            },
            required:             %w[data],
            example:              {
              status:  'success',
              message: 'success',
              data:    {}
            },
            description:          'Success response',
            additionalProperties: false
          },
          success_array:                  {
            type:                 :object,
            properties:           {
              status:  { type: :string },
              message: { type: :string },
              data:    { type: :array }
            },
            required:             %w[data],
            example:              {
              status:  'success',
              message: 'success',
              data:    []
            },
            description:          'Success response',
            additionalProperties: false
          },
          success_pagination:             {
            type:                 :object,
            properties:           {
              status:  { type: :string },
              message: { type: :string },
              data:    { type: :array }
              # pagination: { '$ref' => '#/components/schemas/pagination' }
            },
            required:             %w[data pagination],
            example:              {
              status:     'success',
              message:    'success',
              data:       [],
              pagination: {
                current_page: 1,
                next_page:    2,
                prev_page:    nil,
                total_pages:  1,
                limit_value:  10
              }
            },
            description:          'Success response',
            additionalProperties: false
          },
          video: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              title: { type: 'string' },
              description: { type: 'string', nullable: true },
              url: { type: 'string' },
              created_at: { type: 'string', nullable: true },
            },
            required: %w[id title url]
          },
          user: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              email: { type: 'string' }
            },
            required: %w[id email]
          }
        }
      },
      servers:    [
        {
          url:         '{host}',
          description: 'Testing Server',
          variables:   {
            host: {
              default: 'https://api.ads.dropfoods.com',
              enum:    %w[https://api.ads.dropfoods.com http://localhost:3000]
            }
          }
        }
      ],
      security:   [
        {
          bearerAuth:  [],
          api_version: []
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml

  # To keep your responses clean and validate against a strict schema definition
  config.openapi_strict_schema_validation = true
end

