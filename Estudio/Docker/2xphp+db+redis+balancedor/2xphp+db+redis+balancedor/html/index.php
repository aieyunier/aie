<?php
echo "SERVER 1 <br><br>";
echo "Script de prueba para chequear conexion con MARIADB y REDIS desde PHP <br>";
$servername = "db";
$username = "root";
$password = "m4st3rk3y++";
$dbname = "app1";

// Crear la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar si se estableció la conexión correctamente
if ($conn->connect_error) {
    die("Error al conectar a la base de datos: " . $conn->connect_error);
}

// Ruta del archivo SQL
$sqlFile = "/var/www/html/create_db.sql";

// Leer el contenido del archivo SQL
$sql = file_get_contents($sqlFile);

// Ejecutar el archivo SQL
if ($conn->multi_query($sql) === TRUE) {
    echo "BD Lista ! Comience a llenarla con el formulario que esta al final de la pagina <br>";
} else {
    echo "Error al ejecutar el archivo SQL: " . $conn->error;
}

// Cerrar la conexión
$conn->close();


// Crear la conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// Verificar si se estableció la conexión correctamente
if ($conn->connect_error) {
    die("Error al conectar a la base de datos: " . $conn->connect_error);
}

// Verificar si se envió un formulario para agregar nuevos valores
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombre = $_POST["nombre"];
    $apodo = $_POST["apodo"];

    // Insertar los nuevos valores en la tabla "m7"
    $insertQuery = "INSERT INTO m7 (nombre, apodo) VALUES ('$nombre', '$apodo')";
    if ($conn->query($insertQuery) === TRUE) {
        echo "Nuevo valor agregado exitosamente\n";
    } else {
        echo "Error al agregar el nuevo valor: " . $conn->error . "\n";
    }
}

// Obtener todos los valores de la tabla "m7"
$selectQuery = "SELECT nombre, apodo FROM m7";
$result = $conn->query($selectQuery);

if ($result->num_rows > 0) {
    // Mostrar los valores en una tabla en el navegador
    echo "<table>";
    echo "<tr><th>Nombre</th><th>Apodo</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["nombre"] . "</td><td>" . $row["apodo"] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "No se encontraron valores en la tabla\n";
}

// Cerrar la conexión
$conn->close();

// Conexión a Redis
echo "<br> Probando la conexion con el servidor REDIS..<br>";
$redis = new Redis();
$redis->connect('redis', 6379);

// Operaciones con Redis
echo "Escribiendo (Trabajo, Terminado) en REDIS...<br>";
$redis->set('Trabajo', 'Terminado'); // Establecer un valor en Redis
echo "Leyendo el valor de Trabajo en REDIS...<br>";
$valor = $redis->get('Trabajo'); // Obtener un valor de Redis

// Imprimir el valor obtenido
echo "El valor leido de REDIS en la clave Tabajo es: ".$valor;
// Cerrar la conexión
$redis->close();

?>

<!-- Formulario para agregar nuevos valores -->
<form method="POST" action="<?php echo $_SERVER['PHP_SELF']; ?>">
    <label for="nombre">Nombre:</label>
    <input type="text" name="nombre" required><br>
    <label for="apodo">Apodo:</label>
    <input type="text" name="apodo" required><br>
    <input type="submit" value="Agregar">
</form>
