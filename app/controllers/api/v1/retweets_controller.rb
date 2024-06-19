# frozen_string_literal: true

module Api
  module V1
    class RetweetsController < ApplicationController
      before_action :authenticate_api_v1_user!, only: %i[toggle_retweet]

      def toggle_retweet
        retweet = current_api_v1_user.retweets.find_by(tweet_id: params[:tweet_id])
        if retweet
          retweet.destroy!
          head :no_content
        else
          current_api_v1_user.retweets.create!(tweet_id: params[:tweet_id])
          head :created
        end
      end
    end
  end
end
