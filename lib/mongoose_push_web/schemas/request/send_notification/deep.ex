defmodule MongoosePushWeb.Schemas.Request.SendNotification.Deep do
  alias OpenApiSpex.Schema

  def base() do
    %{
      properties: %{
        service: %Schema{
          type: :string,
          description: "Push notification service",
          format: :text,
          enum: ["fcm", "hns", "apns"]
        },
        mode: %Schema{type: :string, enum: ["prod", "dev"]},
        priority: %Schema{
          type: :string,
          description: "The default one is chosen based on the service being used",
          enum: ["normal", "high"]
        },
        time_to_live: %Schema{type: :integer, format: :int32},
        mutable_content: %Schema{type: :boolean, default: false},
        tags: %Schema{
          type: :array,
          description:
            "Used when choosing pool to match request tags when sending a notification",
          items: %Schema{type: :string, format: :text}
        },
        # Only for APNS, alert/data independent
        topic: %Schema{type: :string},
        data: %Schema{
                type: :object,
                description:
                        "Custom key-values pairs of the message's payload. " <>
                        "The FCM request with nested data can end up with error."
        }
      },
      required: [:service],
      example: %{
        "service" => "apns",
        "mode" => "prod",
        "priority" => "normal",
        "time_to_live" => 3600,
        "mutable_content" => false,
        "tags" => ["some", "tags", "for", "pool", "selection"],
        "topic" => "com.someapp",
        "data" => %{
                "custom" => "data fields",
                "some_id" => 345_645_332,
                "nested" => %{"fields" => "allowed"}
        }
      }
    }
  end

  def alert() do
    %{
      properties: %{
        alert: MongoosePushWeb.Schemas.Request.SendNotification.Deep.Common.Alert
      },
      required: [:alert],
      example: %{
        "alert" => %{
          "body" => "A message from someone",
          "title" => "Notification title",
          "badge" => 7,
          "click_action" => ".SomeApp.Handler.action",
          "tag" => "info",
          "sound" => "standard.mp3"
        }
      }
    }
  end

  def data() do
    %{
      properties: %{
        data: MongoosePushWeb.Schemas.Request.SendNotification.Deep.Common.Data
      },
      required: [:data],
      example: %{
        "data" => %{
          "custom" => "data fields",
          "some_id" => 345_645_332,
          "nested" => %{"fields" => "allowed"}
        }
      }
    }
  end
end
