component persistent="true" table="users" {
    property name="id" fieldtype="id" generator="native";
    property name="firstName" type="string";
    property name="lastName" type="string";
    property name="email" type="string" unique="true";
    property name="password" type="string";
    property name="role" type="string"; // "recipient" or "provider"
    property name="careServices" type="string";
    property name="location" type="string";
    property name="rating" type="numeric";
}

