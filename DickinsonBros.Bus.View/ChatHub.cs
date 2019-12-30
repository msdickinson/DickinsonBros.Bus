using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace DickinsonBros.Bus.View
{
    public class ChatHub : Hub
    {
        //public async Task EnqueueMessage(string userToken, string topicToken, string message)
        //{

        //}

        //public async Task RequestDequeueMessages(string user, string message)
        //{
        //    await Clients..SendAsync("ReceiveMessage", user, message);
        //}

        public async Task AlertSubscribers(string user, string message)
        {
            await Clients.All.SendAsync("ReceiveMessage", user, message);
        }

    }
}
