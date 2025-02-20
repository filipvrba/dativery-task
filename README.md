# Trial Project for [Dativery](https://www.dativery.com/)

This project was created as a solution for an assignment from [Dativery](https://www.dativery.com/). It is designed to fetch JSON data from a website and store it in an XML feed compatible with Shoptet.

## 🚀 Technologies

The project utilizes the required technologies and extends them with an automatic transpilation layer for JavaScript scripts using RB syntax.

### Used Packages:

- **dotenv** (`^16.4.7`) – Loads configuration variables from a `.env` file  
- **node-fetch** (`^3.3.2`) – HTTP client for data retrieval  
- **xmlbuilder2** (`^3.1.1`) – Generates XML files  

## 📁 Project Structure

The project is designed in a modular way, and all JavaScript files use the `.mjs` extension.

### Main Folder Structure:

```txt
.
├── core            # General modules for data manipulation
│   ├── files.mjs   # File operations
│   ├── io.mjs      # Input and output operations
│   └── string.mjs  # String manipulation functions
├── main.mjs        # Main entry point of the program
└── task            # Project-specific modules
    ├── abstracts
    │   └── incremental_data_fetcher.mjs  # Abstract class for incremental data fetching
    ├── net.mjs     # Data fetching module
    └── xml.mjs     # XML feed generation module
```

## 🔧 Main Functionality
1. **Data Fetching** – All product data is retrieved using the `task/net.mjs` script.
2. **Data Processing** – Data manipulation is handled within the `core` modules.
3. **XML Feed Generation** – The final XML file is generated using the `task/xml.mjs` module.

The main script `main.mjs` orchestrates the execution flow and manages program states.

## ▶️ Running the Project

You can run the project using the following command in the terminal:

```bash
node .
```

Make sure all dependencies are installed with:

```bash
npm install
```

Before running, it's recommended to check the `.env` file to ensure it contains the necessary configuration variables.

### Configuration variables:

- **ABRA_AUTH** - This is an authorization password for the given API ("name:password").

## ⚠️ Implementation Notes
- The current implementation allows fast data fetching, but excessive speed may lead to server overload and request blocking.
- A potential solution is to introduce a time delay between requests (e.g., 1 second).
- Attempts to use worker threads for parallelized fetching were unsuccessful due to issues with transferring data between the worker and the `task/net.mjs` script.

## ✅ Summary
This project enables a complete export of stock product data into an XML feed compatible with Shoptet. While some aspects are not fully optimized (e.g., performance during parallel fetching), the core functionality is fully operational.
