/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  email_channels = flatten([
    for email_config in var.notification_channels.email : [
      for email_address, types in email_config : {
        key   = email_address
        email = email_address
        types = types
      }
    ]
  ])
  
  pubsub_channels = flatten([
    for pubsub_config in var.notification_channels.pubsub : [
      for topic_path, types in pubsub_config : {
        key   = topic_path
        topic = topic_path
        types = types
      }
    ]
  ])
}

resource "google_monitoring_notification_channel" "email" {
  for_each = { for ch in local.email_channels : ch.key => ch }
  
  project      = var.project_id
  display_name = each.value.email
  type         = "email"
  labels = {
    email_address = each.value.email
  }
}

resource "google_monitoring_notification_channel" "pubsub" {
  for_each = { for ch in local.pubsub_channels : ch.key => ch }
  
  project      = var.project_id
  display_name = each.value.topic
  type         = "pubsub"
  labels = {
    topic = each.value.topic
  }
}