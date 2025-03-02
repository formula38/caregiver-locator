component restpath="message" {
    remote function sendMessage() httpMethod="POST" restargsource="form" {
        param name="senderId" type="int" required=true;
        param name="receiverId" type="int" required=true;
        param name="messageText" type="string" required=true;

        return createObject("component", "handlers.MessageHandler").sendMessage(senderId, receiverId, messageText);
    }
}
