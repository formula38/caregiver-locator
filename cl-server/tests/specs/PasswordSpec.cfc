component displayName="PasswordSpec" extends="testbox.system.BaseSpec" {

    function run() {
        describe("Password", function () {
            it("hashes with a per-call salt and verifies the original password", function () {
                var passwords = new lib.Password();
                var first = passwords.hashPassword("correct horse battery");
                var second = passwords.hashPassword("correct horse battery");

                expect(first.hash).notToBeEmpty();
                expect(first.salt).notToBeEmpty();
                expect(first.salt).notToBe(second.salt);
                expect(first.hash).notToBe(second.hash);
                expect(passwords.verify("correct horse battery", first.hash, first.salt)).toBeTrue();
                expect(passwords.verify("wrong password", first.hash, first.salt)).toBeFalse();
            });
        });
    }

}
