#!/usr/bin/env ruby
# Encoding: utf-8
#
# Author:: api.jimper@gmail.com (Jonathon Imperiosi)
#
# Copyright:: Copyright 2015, Google Inc. All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
# This example lists all creative fields.
#
# Tags: creativeFields.list

require_relative 'dfareporting_utils'

def get_creative_fields(dfareporting, args)
  # Construct the request
  request = dfareporting.creative_fields.list(
    :profileId => args[:profile_id],
    # Limit the fields returned
    :fields => 'nextPageToken,creativeFields(id,name)'
  )

  loop do
    result = request.execute()

    # Display results
    result.data.creative_fields.each do |field|
      puts 'Found creative field with ID %d and name "%s".' %
          [field.id, field.name]
    end

    token = result.next_page_token

    break unless token and result.data.creative_fields.any?
    request = result.next_page
  end
end

if __FILE__ == $0
  # Retrieve command line arguments
  args = DfaReportingUtils.get_arguments(ARGV, :profile_id)

  # Authenticate and initialize API service
  dfareporting = DfaReportingUtils.setup()

  get_creative_fields(dfareporting, args)
end
