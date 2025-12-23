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

output "email_channels" {
  description = "Email notification channel details"
  value = {
    for k, v in google_monitoring_notification_channel.email : k => {
      id    = v.id
      name  = v.name
      types = local.email_channels[index(local.email_channels.*.key, k)].types
    }
  }
}

output "pubsub_channels" {
  description = "Pub/Sub notification channel details"
  value = {
    for k, v in google_monitoring_notification_channel.pubsub : k => {
      id    = v.id
      name  = v.name
      types = local.pubsub_channels[index(local.pubsub_channels.*.key, k)].types
    }
  }
}

output "all_channel_ids" {
  description = "List of all notification channel IDs"
  value = concat(
    values(google_monitoring_notification_channel.email)[*].id,
    values(google_monitoring_notification_channel.pubsub)[*].id
  )
}