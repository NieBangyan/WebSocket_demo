# WebSocket-Demo

This is a very simple WebSocket communication demo 
- **python Server**:Receive messages and echo them back (Echo Service)
- **Flutter Client**:Connect to server,send messages and display responses

**Core Objective**: Understand the full lifecycle of WebSocket: handshake → communication → closure.

# Project Structure
```
├── python_backend/
│ └── server.py # Python WebSocket server
├── flutter_frontend/ # Flutter client app
├── .gitignore
└── README.md
```

# What is WebSocket?

| Comparison Item | HTTP | WebSocket |
| ---- | ---- | ---- |
| Connection Type | Short connection (disconnected after request-response) | Long connection (persistent) |
| Communication Direction | Only the client can initiate requests actively | Both sides can send messages at any time |
| Real-time Performance | Requires polling with latency | Real-time push |
| Typical Scenarios | Web page loading, API calls | Chat, games, stock quotes |

Core of WebSocket: After the connection is established, the server can actively push data to the client without prior requests from the client.

# Detailed Communication Process
1. Client Connection
   
   Flutter: WebSocketChannel.connect()
   
   Python: Connection received, print "✅ Client connected successfully!"

2. Client Sends Message
   
   Flutter: channel.sink.add("Hello")
   
   Python: Receive "Hello", print "📩 Received: Hello"

3. Server Reply
 
   Python: await websocket.send("Reply: Hello")
   
   Flutter: Stream is triggered, display "Received: Reply: Hello"

4. Client Disconnection
   
   Flutter: channel.sink.close()
   
   Python: Exit the async for loop, print "👋 Client disconnected"

# Common Issue: Why does the connection disconnect immediately?
Common causes:
- Errors in server code (e.g., missing the path parameter in `echo()`)
- Port occupied
- Blocked by firewall
