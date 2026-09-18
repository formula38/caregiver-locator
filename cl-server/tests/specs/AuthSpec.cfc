component displayName="AuthSpec" extends="testbox.system.BaseSpec" {

    function run() {
        describe("Auth", function () {
            it("issues a token that round-trips the user claims", function () {
                var auth = new lib.Auth();
                var user = { id: 42, email: "riley@example.test", role: "recipient" };
                var token = auth.issue(user);
                var payload = auth.verifyToken(token);

                expect(token).notToBeEmpty();
                expect(toString(payload.sub)).toBe("42");
                expect(payload.email).toBe("riley@example.test");
                expect(payload.role).toBe("recipient");
            });

            it("rejects a missing bearer token", function () {
                var auth = new lib.Auth();
                var result = auth.requireUser({});
                expect(result.ok).toBeFalse();
                expect(result.message).toInclude("Missing");
            });

            it("rejects a tampered token", function () {
                var auth = new lib.Auth();
                var token = auth.issue({ id: 1, email: "a@b.test", role: "provider" });
                var result = auth.requireUser({ Authorization: "Bearer " & token & "nope" });
                expect(result.ok).toBeFalse();
            });
        });
    }

}
