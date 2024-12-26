component persistent="true"{
    property name="id" generator="native";
    property name="email" ormtype="string" notnull="true" unique="true";
    property name="password" ormType="string" notnull="true";
    property name="role" ormtype="string" default="client"; // client or caregiver

    // optionally add relationships or methods here
}