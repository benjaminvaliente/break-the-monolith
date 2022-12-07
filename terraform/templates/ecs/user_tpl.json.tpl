[
    {
      "essential": true,
      "memoryReservation": null,
      "image": "${app_image}",
      "name": "user-app",
      "portMappings": [
        {
          "hostPort": ${app_port},
          "protocol": "tcp",
          "containerPort": ${app_port}
        }
      ],
      "environment": []
    }
  ]