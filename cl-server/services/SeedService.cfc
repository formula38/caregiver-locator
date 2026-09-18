component {

    public any function init() {
        variables.users = new services.UserService();
        variables.profiles = new services.ProfileService();
        variables.reviews = new services.ReviewService();
        variables.matches = new services.MatchService();
        variables.messages = new services.MessageService();
        return this;
    }

    public void function ensureDemoData() {
        var count = new lib.Db().execute("SELECT COUNT(*) AS n FROM users", []);
        if (count.n > 0) {
            return;
        }

        var recipient = variables.users.register(
            email = "recipient@example.test",
            password = "password123",
            firstName = "Riley",
            lastName = "Chen",
            role = "recipient"
        );
        variables.profiles.updateMine(
            userId = recipient.id,
            careServices = "",
            location = "Oakland",
            bio = "Looking for weekday personal care near Lake Merritt."
        );

        var avery = variables.users.register(
            email = "avery.nguyen@example.test",
            password = "password123",
            firstName = "Avery",
            lastName = "Nguyen",
            role = "provider"
        );
        variables.profiles.updateMine(
            userId = avery.id,
            careServices = "personal_care,medication",
            location = "Oakland",
            bio = "Ten years of in-home support. Medication reminders and transfers."
        );

        var jordan = variables.users.register(
            email = "jordan.lee@example.test",
            password = "password123",
            firstName = "Jordan",
            lastName = "Lee",
            role = "provider"
        );
        variables.profiles.updateMine(
            userId = jordan.id,
            careServices = "companion,personal_care",
            location = "Oakland",
            bio = "Companion care and light housekeeping in East Bay."
        );

        var sam = variables.users.register(
            email = "sam.okonkwo@example.test",
            password = "password123",
            firstName = "Sam",
            lastName = "Okonkwo",
            role = "provider"
        );
        variables.profiles.updateMine(
            userId = sam.id,
            careServices = "respite,personal_care",
            location = "Berkeley",
            bio = "Respite and personal care. Available evenings."
        );

        variables.reviews.create(reviewerId = recipient.id, revieweeId = avery.id, rating = 5, comment = "Punctual and careful.");
        variables.reviews.create(reviewerId = recipient.id, revieweeId = jordan.id, rating = 4, comment = "Warm companion, a bit late once.");
        variables.matches.save(recipientId = recipient.id, providerId = avery.id);
        variables.messages.send(senderId = recipient.id, receiverId = avery.id, messageText = "Hi Avery, are you free Thursday morning?");
    }

}
