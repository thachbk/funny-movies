require 'swagger_helper'

RSpec.describe 'api/v1/videos' do
  path '/api/videos' do
    get 'List all videos' do
      include_context 'rswag_context'
      tags 'Videos'
      security [api_version: []]
      produces 'application/json'

      response '200', 'videos found' do
        schema type:       :object,
               properties: {
                 status:  { type: :string },
                 message: { type: :string },
                 data:    {
                   type:  :array,
                   items: {
                     '$ref' => '#/components/schemas/video'
                   }
                 }
               },
               required:   %w[status message data]

        run_test!
      end
    end

    post 'Create a video' do
      include_context 'rswag_context'
      tags 'Videos'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :video, in: :body, schema: {
        type:       :object,
        properties: {
          video: {
            type:       :object,
            properties: {
              url: { type: :string }
            },
            required:   %w[url]
          }
        },
        required:   %w[video]
      }
      let(:video_data) { build(:video, :with_valid_url) }
      let(:video) { { video: { url: video_data.url } } }

      it_behaves_like 'authenticatable'

      response '200', 'video created' do
        schema type:       :object,
               properties: {
                 status:  { type: :string },
                 message: { type: :string },
                 data:    {
                   '$ref' => '#/components/schemas/video'
                 }
               },
               required:   %w[status message data]

        before do
          fetch_ytb_info_cmd_instance = instance_double(Videos::FetchYtbInfoCmd)
          allow(Videos::FetchYtbInfoCmd).to receive(:call).and_return(fetch_ytb_info_cmd_instance)
          # allow(fetch_ytb_info_cmd_instance).to receive(:success?).and_return(true)
          allow(fetch_ytb_info_cmd_instance).to receive_messages(success?: true, result: {
            title:       video_data.title,
            description: video_data.description,
            url:         video_data.url
          })
        end

        let(:video_data) { build(:video, :with_valid_url) }
        let(:video) { { url: video_data.url } }

        run_test! do |response|
          data = JSON.parse(response.body)

          expected_data = {
            'title'       => video_data.title,
            'description' => video_data.description,
            'url'         => video_data.url
          }

          expect(data['data']).to include(expected_data)
        end
      end

      response '200', 'invalid request' do
        schema '$ref' => '#/components/schemas/error'

        let(:video_data) { build(:video, :with_invalid_url) }
        let(:video) { { video: { url: video_data.url } } }

        run_test!
      end
    end
  end
end
