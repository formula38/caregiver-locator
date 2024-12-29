<cfinclude template="header.cfm">

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Caregiver Locator</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <header>
        <h1>Caregiver Locator</h1>
    </header>

    <div class="container">
        <!-- Welcome Section -->
        <section>
            <h3>Welcome to ColdFusion!</h3>
            <p>Server OS: <cfoutput>#createObject("java", "java.lang.System").getProperty("os.name")#</cfoutput></p>
            <p>Server Time: <cfoutput>#timeFormat(now(), "hh:mm:ss tt")#</cfoutput></p>
            <p>Client IP: <cfoutput>#cgi.remote_addr#</cfoutput></p>
        </section>

        <!-- Database Section -->
        <section>
            <h3>Caregiver List</h3>
            <!-- Create table if it doesn't exist -->
            <cfquery datasource="careDS">
                CREATE TABLE IF NOT EXISTS caregivers (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(50),
                    specialization VARCHAR(50),
                    rating INT
                );
            </cfquery>

            <!-- Insert sample data if the table is empty -->
            <cfquery datasource="careDS" name="checkData">
                SELECT COUNT(*) AS recordCount FROM caregivers;
            </cfquery>

            <cfif checkData.recordCount EQ 0>
                <cfquery datasource="careDS">
                    INSERT INTO caregivers (name, specialization, rating)
                    VALUES
                    ('Alice', 'Nursing', 5),
                    ('Bob', 'Housekeeping', 4),
                    ('Charlie', 'Personal Care', 3);
                </cfquery>
            </cfif>

            <!-- Fetch and display data -->
            <cfquery name="getCaregivers" datasource="careDS">
                SELECT * FROM caregivers;
            </cfquery>

            <cfif getCaregivers.recordCount GT 0>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Specialization</th>
                            <th>Rating</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="getCaregivers">
                            <tr>
                                <td>#name#</td>
                                <td>#specialization#</td>
                                <td>#rating#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            <cfelse>
                <p>No caregivers found.</p>
            </cfif>
        </section>

        <!-- Form Section -->
        <section>
            <h3>Add a Caregiver</h3>
            <form method="post" action="index.cfm">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>

                <label for="specialization">Specialization:</label>
                <input type="text" id="specialization" name="specialization" required>

                <label for="rating">Rating:</label>
                <input type="number" id="rating" name="rating" required min="1" max="5">

                <input type="submit" value="Submit">
            </form>

            <!-- Handle form submission -->
            <cfif structKeyExists(form, "name") AND structKeyExists(form, "specialization") AND structKeyExists(form, "rating")>
                <cfquery datasource="careDS">
                    INSERT INTO caregivers (name, specialization, rating)
                    VALUES
                    (<cfqueryparam value="#form.name#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#form.specialization#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#form.rating#" cfsqltype="cf_sql_integer">);
                </cfquery>
                <p>Submitted Data:</p>
                <p>Name: <cfoutput>#form.name#</cfoutput></p>
                <p>Specialization: <cfoutput>#form.specialization#</cfoutput></p>
                <p>Rating: <cfoutput>#form.rating#</cfoutput></p>
            </cfif>
        </section>

        <!-- JSON Parsing Section -->
        <section>
            <h3>Parsed JSON Data</h3>
            <cfscript>
                jsonData = '[
                    {"name": "Alice", "specialization": "Nursing", "rating": 5},
                    {"name": "Bob", "specialization": "Housekeeping", "rating": 4}
                ]';
                caregivers = deserializeJson(jsonData);
            </cfscript>

            <ul>
                <cfoutput>
                    <cfloop array="#caregivers#" index="caregiver">
                        <li>#caregiver.name# - #caregiver.specialization# (Rating: #caregiver.rating#)</li>
                    </cfloop>
                </cfoutput>
            </ul>
        </section>
    </div>
</body>
</html>
