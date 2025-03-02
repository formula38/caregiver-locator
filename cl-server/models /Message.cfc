component persistent="true" table="messages" {
    property name="id" fieldtype="id" generator="native";
    property name="senderId" type="int";
    property name="receiverId" type="int";
    property name="messageText" type="string";
    property name="sentAt" type="timestamp";
}

