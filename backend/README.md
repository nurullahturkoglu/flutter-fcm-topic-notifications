# FCM Notification Backend

Backend server for sending FCM push notifications via topics and tokens.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Add your Firebase service account key:
   - Download `serviceAccountKey.json` from Firebase Console
   - Place it in the `backend` directory

3. Start the server:
```bash
npm start
```

For development with auto-reload:
```bash
npm run dev
```

## API Endpoints

### POST /api/topic/notify
Send notification to all devices subscribed to "everyone" topic.

Request body:
```json
{
  "title": "Notification Title",
  "body": "Notification Body"
}
```

### POST /api/token/notify
Send notification to a specific device using FCM token.

Request body:
```json
{
  "token": "FCM_TOKEN_HERE",
  "title": "Notification Title",
  "body": "Notification Body"
}
```

### GET /health
Health check endpoint.

## Environment Variables

- `PORT`: Server port (default: 3000)

