require 'rails_helper'
require "rspec/json_expectations"

RSpec.describe "Posts", type: :request do
    describe "Testing V1 Request/Controllers without Authentication" do
        before do 
            @post = create(:post)
        end
        
        it "INDEX 200 OK" do
            get "/v1/posts.json"

            expect(response).to have_http_status(200)
            expect(response.body).to include_json([
                "id" => /\d/,
                "title" => (be_a_kind_of String),
                "body" => (be_a_kind_of String)
            ])
        end
    end
    
    describe "Testing V1 Request/Controllers with Authentication" do
        before do 
            @post = create(:post)
        end

        it "CREATE 201 Created" do
            
            headers = {"ACCPET" => "application/json"}

            post_params = attributes_for(:post)
      
            post "/v1/posts.json", params: {post: post_params}, headers: headers
      
            expect(response).to have_http_status(201)
            expect(response.body).to include_json(
                "id" => /\d/,
                "title" => (be_a_kind_of String),
                "body" => (be_a_kind_of String)
            )
        end

        it "SHOW 201 OK" do
            get "/v1/posts/#{@post.id}.json"
      
            expect(response).to have_http_status(200)
            expect(response.body).to include_json(
                "id" => /\d/,
                "title" => (be_a_kind_of String),
                "body" => (be_a_kind_of String)
            )
        end

        it "UPDATE 200 Updated" do      
            headers = {"ACCPET" => "application/json"}
            @post.title += " - UPDATE"
      
            patch "/v1/posts/#{@post.id}.json",  params: {post: @post.attributes}, headers: headers
      
            expect(response).to have_http_status(200)
            expect(response.body).to include_json(
                "id" => /\d/,
                "title" => (be_a_kind_of String),
                "body" => (be_a_kind_of String)
            )
        end

        it "DELETE 204 No Content" do
            headers = {"ACCPET" => "application/json"}
      
            expect {delete "/v1/posts/#{@post.id}.json",  headers: headers}.to change(Post, :count).by(-1)      
            expect(response).to have_http_status(204)
        end
    end
end