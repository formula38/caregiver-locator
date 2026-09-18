component {

    public any function init() {
        variables.db = new lib.Db();
        return this;
    }

    public struct function send(required numeric senderId, required numeric receiverId, required string messageText) {
        if (senderId == receiverId) {
            throw(type = "MessageService.Invalid", errorCode = "SELF_MESSAGE", message = "You cannot message yourself");
        }
        var inserted = variables.db.execute("
            INSERT INTO messages (sender_id, receiver_id, message_text)
            VALUES (?, ?, ?)
            RETURNING id, sender_id, receiver_id, message_text, sent_at
        ", [
            variables.db.p(senderId, "cf_sql_integer"),
            variables.db.p(receiverId, "cf_sql_integer"),
            variables.db.p(messageText)
        ]);
        return toPublicMessage(variables.db.first(inserted));
    }

    public array function threads(required numeric userId) {
        var qry = variables.db.execute("
            SELECT
                other_id,
                u.first_name,
                u.last_name,
                latest.message_text,
                latest.sent_at
            FROM (
                SELECT DISTINCT ON (other_id)
                    other_id,
                    message_text,
                    sent_at
                FROM (
                    SELECT
                        CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END AS other_id,
                        message_text,
                        sent_at
                    FROM messages
                    WHERE sender_id = ? OR receiver_id = ?
                ) conversation
                ORDER BY other_id, sent_at DESC
            ) latest
            INNER JOIN users u ON u.id = latest.other_id
            ORDER BY latest.sent_at DESC
        ", [
            variables.db.p(userId, "cf_sql_integer"),
            variables.db.p(userId, "cf_sql_integer"),
            variables.db.p(userId, "cf_sql_integer")
        ]);
        var results = [];
        for (var row in qry) {
            arrayAppend(results, {
                "userId": row.other_id,
                "name": row.first_name & " " & row.last_name,
                "lastMessage": row.message_text,
                "sentAt": toString(row.sent_at)
            });
        }
        return results;
    }

    public array function thread(required numeric userId, required numeric otherUserId) {
        var qry = variables.db.execute("
            SELECT id, sender_id, receiver_id, message_text, sent_at
            FROM messages
            WHERE (sender_id = ? AND receiver_id = ?)
               OR (sender_id = ? AND receiver_id = ?)
            ORDER BY sent_at ASC
        ", [
            variables.db.p(userId, "cf_sql_integer"),
            variables.db.p(otherUserId, "cf_sql_integer"),
            variables.db.p(otherUserId, "cf_sql_integer"),
            variables.db.p(userId, "cf_sql_integer")
        ]);
        var results = [];
        for (var row in qry) {
            arrayAppend(results, toPublicMessage(row));
        }
        return results;
    }

    private struct function toPublicMessage(required struct row) {
        return {
            "id": row.id,
            "senderId": row.sender_id,
            "receiverId": row.receiver_id,
            "messageText": row.message_text,
            "sentAt": structKeyExists(row, "sent_at") ? toString(row.sent_at) : ""
        };
    }

}
