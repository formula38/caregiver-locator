component {

    public any function init() {
        variables.messages = new services.MessageService();
        variables.response = new lib.Response();
        variables.validation = new lib.Validation();
        return this;
    }

    public struct function send(required struct requestContext) {
        var body = requestContext.body;
        var errors = variables.validation.requireFields(body, ["receiverId", "messageText"]);
        if (arrayLen(errors)) {
            return variables.response.unprocessable(errors);
        }
        try {
            var message = variables.messages.send(
                senderId = requestContext.user.id,
                receiverId = val(body.receiverId),
                messageText = body.messageText
            );
            return variables.response.created({ "message": message });
        } catch (MessageService.Invalid e) {
            return variables.response.badRequest(e.message);
        }
    }

    public struct function threads(required struct requestContext) {
        return variables.response.ok({
            "threads": variables.messages.threads(requestContext.user.id)
        });
    }

    public struct function thread(required struct requestContext) {
        return variables.response.ok({
            "messages": variables.messages.thread(
                userId = requestContext.user.id,
                otherUserId = val(requestContext.params.userId)
            )
        });
    }

}
