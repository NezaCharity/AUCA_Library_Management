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

            <label for="phoneNumber">Phone Number:</label>
            <input type="text" id="phoneNumber" name="phoneNumber" required pattern="[0-9]{10}" placeholder="e.g., 0781234567">

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
            <label for="province">Province:</label>
            <select id="province" name="province" required onchange="updateDistricts()">
                <option value="">Select Province</option>
                <option value="East">East</option>
                <option value="North">North</option>
                <option value="West">West</option>
                <option value="South">South</option>
                <option value="Kigali">Kigali</option>
            </select>

            <label for="district">District:</label>
            <select id="district" name="district" required onchange="updateSectors()">
                <option value="">Select District</option>
            </select>

            <label for="sector">Sector:</label>
            <select id="sector" name="sector" required onchange="updateCells()">
                <option value="">Select Sector</option>
            </select>

            <label for="cell">Cell:</label>
            <select id="cell" name="cell" required onchange="updateVillages()">
                <option value="">Select Cell</option>
            </select>

            <label for="village">Village:</label>
            <select id="village" name="village" required>
                <option value="">Select Village</option>
            </select>

            <button type="submit">Register</button>
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </form>
    </div>
</div>

<!-- JavaScript to Dynamically Update Districts, Sectors, Cells, and Villages -->
<script>
    const districtsByProvince = {
        "East": ["Nyagatare", "Rwamagana", "Kayonza"],
        "North": ["Musanze", "Gicumbi", "Rulindo"],
        "West": ["Rubavu", "Karongi", "Nyamasheke"],
        "South": ["Huye", "Nyanza", "Gisagara"],
        "Kigali": ["Gasabo", "Kicukiro", "Nyarugenge"]
    };

    const sectorsByDistrict = {
        "Nyagatare": ["Nyagatare", "Katabagemu", "Rukomo"],
        "Rwamagana": ["Rwamagana", "Muhazi", "Gishari"],
        "Kayonza": ["Kayonza", "Mukarange", "Murundi"],
        "Musanze": ["Musanze", "Kinigi", "Busogo"],
        "Gicumbi": ["Gicumbi", "Rutare", "Mutete"],
        "Rulindo": ["Rulindo", "Shyorongi", "Kisaro"],
        "Rubavu": ["Rubavu", "Nyamyumba", "Kanama"],
        "Karongi": ["Karongi", "Murambi", "Mubuga"],
        "Nyamasheke": ["Nyamasheke", "Kanjongo", "Karambi"],
        "Huye": ["Huye", "Mbazi", "Rusatira"],
        "Nyanza": ["Nyanza", "Busasamana", "Mukingo"],
        "Gisagara": ["Gisagara", "Kansi", "Mamba"],
        "Gasabo": ["Kacyiru", "Kimironko", "Remera"],
        "Kicukiro": ["Kicukiro", "Niboye", "Kanombe"],
        "Nyarugenge": ["Nyamirambo", "Gitega", "Muhima"]
    };

    const cellsBySector = {
        // Nyagatare
        "Nyagatare": ["Nyagatare Cell 1", "Nyagatare Cell 2"],
        "Katabagemu": ["Katabagemu Cell 1", "Katabagemu Cell 2"],
        "Rukomo": ["Rukomo Cell 1", "Rukomo Cell 2"],
        
        // Rwamagana
        "Rwamagana": ["Rwamagana Cell 1", "Rwamagana Cell 2"],
        "Muhazi": ["Muhazi Cell 1", "Muhazi Cell 2"],
        "Gishari": ["Gishari Cell 1", "Gishari Cell 2"],
        
        // Kayonza
        "Kayonza": ["Kayonza Cell 1", "Kayonza Cell 2"],
        "Mukarange": ["Mukarange Cell 1", "Mukarange Cell 2"],
        "Murundi": ["Murundi Cell 1", "Murundi Cell 2"],

        // Gasabo
        "Kacyiru": ["Gacuriro", "Nyarutarama"],
        "Kimironko": ["Bibare", "Kibagabaga"],
        "Remera": ["Rukiri I", "Rukiri II"],

        // Kicukiro
        "Kicukiro": ["Kicukiro Cell 1", "Kicukiro Cell 2"],
        "Niboye": ["Niboye Cell 1", "Niboye Cell 2"],
        "Kanombe": ["Kanombe Cell 1", "Kanombe Cell 2"],

        // Nyarugenge
        "Nyamirambo": ["Nyamirambo Cell 1", "Nyamirambo Cell 2"],
        "Gitega": ["Gitega Cell 1", "Gitega Cell 2"],
        "Muhima": ["Muhima Cell 1", "Muhima Cell 2"]
    };

    const villagesByCell = {
        // Nyagatare Cells
        "Nyagatare Cell 1": ["Village A", "Village B"],
        "Nyagatare Cell 2": ["Village C", "Village D"],
        "Katabagemu Cell 1": ["Village E", "Village F"],
        "Katabagemu Cell 2": ["Village G", "Village H"],
        "Rukomo Cell 1": ["Village I", "Village J"],
        "Rukomo Cell 2": ["Village K", "Village L"],

        // Rwamagana Cells
        "Rwamagana Cell 1": ["Village M", "Village N"],
        "Rwamagana Cell 2": ["Village O", "Village P"],
        "Muhazi Cell 1": ["Village Q", "Village R"],
        "Muhazi Cell 2": ["Village S", "Village T"],
        "Gishari Cell 1": ["Village U", "Village V"],
        "Gishari Cell 2": ["Village W", "Village X"],

        // Kayonza Cells
        "Kayonza Cell 1": ["Village Y", "Village Z"],
        "Kayonza Cell 2": ["Village AA", "Village AB"],
        "Mukarange Cell 1": ["Village AC", "Village AD"],
        "Mukarange Cell 2": ["Village AE", "Village AF"],
        "Murundi Cell 1": ["Village AG", "Village AH"],
        "Murundi Cell 2": ["Village AI", "Village AJ"],

        // Gasabo Cells
        "Gacuriro": ["Village G1", "Village G2"],
        "Nyarutarama": ["Village N1", "Village N2"],
        "Bibare": ["Village B1", "Village B2"],
        "Kibagabaga": ["Village K1", "Village K2"],
        "Rukiri I": ["Village R1", "Village R2"],
        "Rukiri II": ["Village S1", "Village S2"],

        // Kicukiro Cells
        "Kicukiro Cell 1": ["Village KC1", "Village KC2"],
        "Kicukiro Cell 2": ["Village KC3", "Village KC4"],
        "Niboye Cell 1": ["Village NB1", "Village NB2"],
        "Niboye Cell 2": ["Village NB3", "Village NB4"],
        "Kanombe Cell 1": ["Village KN1", "Village KN2"],
        "Kanombe Cell 2": ["Village KN3", "Village KN4"],

        // Nyarugenge Cells
        "Nyamirambo Cell 1": ["Village NM1", "Village NM2"],
        "Nyamirambo Cell 2": ["Village NM3", "Village NM4"],
        "Gitega Cell 1": ["Village GT1", "Village GT2"],
        "Gitega Cell 2": ["Village GT3", "Village GT4"],
        "Muhima Cell 1": ["Village MH1", "Village MH2"],
        "Muhima Cell 2": ["Village MH3", "Village MH4"]
    };


</script>
<script>




    function updateDistricts() {
        const province = document.getElementById("province").value;
        const districtSelect = document.getElementById("district");
        districtSelect.innerHTML = '<option value="">Select District</option>';
        
        if (districtsByProvince[province]) {
            districtsByProvince[province].forEach(district => {
                const option = document.createElement("option");
                option.value = district;
                option.textContent = district;
                districtSelect.appendChild(option);
            });
        }
        document.getElementById("sector").innerHTML = '<option value="">Select Sector</option>';
        document.getElementById("cell").innerHTML = '<option value="">Select Cell</option>';
        document.getElementById("village").innerHTML = '<option value="">Select Village</option>';
    }

    function updateSectors() {
        const district = document.getElementById("district").value;
        const sectorSelect = document.getElementById("sector");
        sectorSelect.innerHTML = '<option value="">Select Sector</option>';
        
        if (sectorsByDistrict[district]) {
            sectorsByDistrict[district].forEach(sector => {
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
        const sector = document.getElementById("sector").value;
        const cellSelect = document.getElementById("cell");
        cellSelect.innerHTML = '<option value="">Select Cell</option>';
        
        if (cellsBySector[sector]) {
            cellsBySector[sector].forEach(cell => {
                const option = document.createElement("option");
                option.value = cell;
                option.textContent = cell;
                cellSelect.appendChild(option);
            });
        }
        document.getElementById("village").innerHTML = '<option value="">Select Village</option>';
    }

    function updateVillages() {
        const cell = document.getElementById("cell").value;
        const villageSelect = document.getElementById("village");
        villageSelect.innerHTML = '<option value="">Select Village</option>';
        
        if (villagesByCell[cell]) {
            villagesByCell[cell].forEach(village => {
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
