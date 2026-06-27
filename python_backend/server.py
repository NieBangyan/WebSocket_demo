import asyncio
import websockets

async def echo(websocket, path):
    try:
        print("✅ client connected!")
        async for message in websocket:
            print(f"📩 received: {message}")
            await websocket.send(f"reply: {message}")
            print(f"📤 sent reply: {message}")
    except websockets.exceptions.ConnectionClosed:
        print("👋 client disconnected")
    except Exception as e:
        print(f"❌ error: {e}")

async def main():
    async with websockets.serve(echo, "127.0.0.1", 8765):
        print("🚀 WebSocket service started")
        print("📡 address: ws://127.0.0.1:8765")
        print("⏳ waiting for client connection...")
        await asyncio.Future()

if __name__ == "__main__":
    asyncio.run(main())