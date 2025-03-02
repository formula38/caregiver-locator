component {
    remote function sendMessage(senderId, receiverId, messageText) {
        var newMessage = entityNew("Message");
        
        newMessage.setSenderId(senderId);
        newMessage.setReceiverId(receiverId);
        newMessage.setMessageText(messageText);
        newMessage.setSentAt(now());

        entitySave(newMessage);

        return { success: true, message: "Message sent successfully!" };
    }
}
