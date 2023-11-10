namespace MyWebSocket
{
    public class MyWebsocketMessage
    {
        private byte[] ctx;
        private string type;
        private ulong connection_id;

        public MyWebsocketMessage(byte[] ctx, string type, ulong connectionID)
        {
            this.ctx = ctx;
            this.type = type;
            connection_id = connectionID;
        }

        public byte[] Ctx => ctx;

        public ulong ConnectionID => connection_id;

        public string Type => type;
    }
}