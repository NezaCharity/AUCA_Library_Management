<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - AUCA Library Management</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="container">
    <header>
        <h2>Create Your AUCA Library Account</h2>
    </header>
    <div class="card">
        <form action="registerServlet" method="post">
            <h3>Register</h3>
            
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <label for="role">Role:</label>
            <select id="role" name="role" required>
                <option value="student">Student</option>
                <option value="teacher">Teacher</option>
                <option value="librarian">Librarian</option>
                <option value="HOD">Head of Department</option>
                <option value="dean">Dean</option>
            </select>

            <label for="membership">Membership Type:</label>
            <select id="membership" name="membership" required>
                <option value="gold">Gold</option>
                <option value="silver">Silver</option>
                <option value="striver">Striver</option>
            </select>

            <!-- Location Fields -->
            <h3>Location</h3>

            <label for="district">District:</label>
            <select id="district" name="district" required onchange="updateSectors()">
                <option value="">Select District</option>
                <option value="Gasabo">Gasabo</option>
                <option value="Kicukiro">Kicukiro</option>
                <option value="Nyarugenge">Nyarugenge</option>
            </select>

            <label for="sector">Sector:</label>
            <select id="sector" name="sector" required onchange="updateCells()">
                <option value="">Select Sector</option>
                <!-- Options will be populated by JavaScript -->
            </select>

            <label for="cell">Cell:</label>
            <select id="cell" name="cell" required onchange="updateVillages()">
                <option value="">Select Cell</option>
                <!-- Options will be populated by JavaScript -->
            </select>

            <label for="village">Village:</label>
            <select id="village" name="village" required>
                <option value="">Select Village</option>
                <!-- Options will be populated by JavaScript -->
            </select>

            <button type="submit">Register</button>
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </form>
    </div>
</div>

<!-- JavaScript to Dynamically Update Sectors, Cells, and Villages -->
<script>
    const sectorsByDistrict = {
        "Gasabo": ["Kimironko", "Kacyiru", "Remera", "Gisozi"],
        "Kicukiro": ["Kicukiro", "Gahanga", "Kagarama", "Niboye"],
        "Nyarugenge": ["Nyamirambo", "Nyakabanda", "Kimisagara"]
    };

    const cellsBySector = {
        "Kimironko": ["Bibare", "Kibagabaga", "Nyagatovu"],
        "Kacyiru": ["Gacuriro", "Nyarutarama"],
        "Remera": ["Rukiri I", "Rukiri II"],
        "Gisozi": ["Murama", "Nyamabuye"],
        "Kicukiro": ["Kicukiro Centre", "Nyanza"],
        "Gahanga": ["Kabuga", "Kagasa"],
        "Kagarama": ["Kanombe", "Mageragere"],
        "Niboye": ["Rubirizi", "Gikondo"],
        "Nyamirambo": ["Mumena", "Rugarama"],
        "Nyakabanda": ["Nyakabanda I", "Nyakabanda II"],
        "Kimisagara": ["Agatare", "Biryogo"]
    };

    const villagesByCell = {
        "Bibare": ["Ingenzi", "Imena", "Imitari"],
        "Kibagabaga": ["Akintwari", "Kageyo", "Gasharu"],
        "Nyagatovu": ["Ijabiro", "Isangano"],
        "Gacuriro": ["Kagarama", "Kigabiro"],
        "Nyarutarama": ["Nyakabingo", "Kinyinya"],
        "Rukiri I": ["Agatenga", "Gikondo"],
        "Rukiri II": ["Imena", "Rwampara"],
        "Murama": ["Gihogere", "Kabuga"],
        "Nyamabuye": ["Ubumwe", "Giticyinyoni"],
        "Kicukiro Centre": ["Nyarugunga", "Rwabugiri"],
        "Nyanza": ["Kabuga", "Mageragere"],
        "Kabuga": ["Akabuga", "Kigina"],
        "Kagasa": ["Kinyinya", "Nyarubuye"],
        "Kanombe": ["Gahoromani", "Gikoma"],
        "Mageragere": ["Gikomero", "Gasogi"],
        "Rubirizi": ["Kabeza", "Kabuga"],
        "Gikondo": ["Nyanza I", "Nyanza II"],
        "Mumena": ["Akabuga", "Rwampala"],
        "Rugarama": ["Kabirizi", "Kinyinya"],
        "Nyakabanda I": ["Cyahafi", "Nyarubuye"],
        "Nyakabanda II": ["Nyanza", "Kabeza"],
        "Agatare": ["Nyabisindu", "Gisozi"],
        "Biryogo": ["Gikondo", "Remera"]
    };

    function updateSectors() {
        const districtSelect = document.getElementById("district");
        const sectorSelect = document.getElementById("sector");
        const selectedDistrict = districtSelect.value;

        sectorSelect.innerHTML = '<option value="">Select Sector</option>';
        if (sectorsByDistrict[selectedDistrict]) {
            sectorsByDistrict[selectedDistrict].forEach(sector => {
                const option = document.createElement("option");
                option.value = sector;
                option.textContent = sector;
                sectorSelect.appendChild(option);
            });
        }
        document.getElementById("cell").innerHTML = '<option value="">Select Cell</option>';
        document.getElementById("village").innerHTML = '<option value="">Select Village</option>';
    }

    function updateCells() {
        const sectorSelect = document.getElementById("sector");
        const cellSelect = document.getElementById("cell");
        const selectedSector = sectorSelect.value;

        cellSelect.innerHTML = '<option value="">Select Cell</option>';
        if (cellsBySector[selectedSector]) {
            cellsBySector[selectedSector].forEach(cell => {
                const option = document.createElement("option");
                option.value = cell;
                option.textContent = cell;
                cellSelect.appendChild(option);
            });
        }
        document.getElementById("village").innerHTML = '<option value="">Select Village</option>';
    }

    function updateVillages() {
        const cellSelect = document.getElementById("cell");
        const villageSelect = document.getElementById("village");
        const selectedCell = cellSelect.value;

        villageSelect.innerHTML = '<option value="">Select Village</option>';
        if (villagesByCell[selectedCell]) {
            villagesByCell[selectedCell].forEach(village => {
                const option = document.createElement("option");
                option.value = village;
                option.textContent = village;
                villageSelect.appendChild(option);
            });
        }
    }
</script>

</body>
</html>
