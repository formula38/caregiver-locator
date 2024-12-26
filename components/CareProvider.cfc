component persistent="true" {
    property name="id" fieldtype="id" generator="native";
    property name="name" ormType="string" notnull="true";
    property name="location" ormType="string" notnull="true";
    property name="specialization" ormType="string";
    property name="availability" ormType="boolean" default="true";
    property name="bio" ormType="text";

    // Define relationships and other properties as needed
}
