# Event Organizer

This is an application to create an event with title, description, hostname and organizations it belong.

Once you create an event, events can be viewed based on following filters.

* Number of events ( count )
* By organization name
* By host name
* By organization and host name
* By organization, host name and number of events

All events are returned in reverse chronological order.

List of exposed APIS for achieving above:

Create a new event:

URL: HOSTNAME/events
Method: POST
Payload: 

{ "event" : {"title": "Programming test event",
  "description": "Programming test",
  "hostname": "programhost.com",
  "organizations": ["GTM"]
   }
}

Response:
{
  "data": {
    "id": 1,
    "title": "Programming test event",
    "description": "Programming test",
    "hostname": "programhost.com",
    "organizations": ["GTM"],
    "event_date_time": "30-09-2016 06:58:33"
  },
  "message": "Event created",
  "status": 200
}

GET Events:
Method: GET

1) Fetch all events:
URL: HOSTNAME/events

Response:
{
  "data": [
    {
      "id": 1,
      "title": "Programming test event",
      "description": "Programming test",
      "hostname": "programhost.com",
      "organizations": ["GTM"],
      "event_date_time": "30-09-2016 06:39:25"
    },
  ],
  "message": "All events returned",
  "status": 200
}

2) Fetch last 5 events:
URL: HOSTNAME/events?count=5

3) Fetch GTM organization events:
URL: HOSTNAME/events?organization=GTM

4) Fetch programhost.com events:
URL: HOSTNAME/events?hostname=programhost.com

5) Fetch GTM organization with programhost.com events:
URL: HOSTNAME/events?hostname=programhost.com&organization=GTM

6) Fetch GTM organization 5 events with programhost.com:
URL: HOSTNAME/events?hostname=programhost.com&organization=GTM&count=5

All APIS should sent token for authentication to make it secure. Token is configured in config/application.rb.
