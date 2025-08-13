# api\_genius 🚀

A powerful Flutter plugin for generating code from a Postman Collection.

  - **Generates** Dart code for API services, models, and controllers.
  - **Automates** the creation of network requests and data handling logic.
  - **Reduces** repetitive coding and improves development speed.

-----

### 📦 Structure

The plugin generates a modular structure: `constants`, `services`, `models`, `controllers`, and an `examples` folder.

  - **Dependencies**: `http` for API calls, `GetX` for state management.
  - **Input**: Requires a **Postman Collection (v2.1) JSON file**.

-----

### 🛠️ Usage

1.  **Export** your Postman Collection as a `v2.1` JSON file and rename it to **`postman_collection.json`**.

2.  **Place** the `postman_collection.json` file in either the `assets/` directory of your project.

3.  **Run** the following command to generate the code:

    ```bash
    flutter pub run api_genius
    ```

-----

### 📝 Notes

  - **Serialization**: JSON serialization is manual; no code is generated for it.
  - **No Extra Packages**: The plugin doesn't add any extra dependencies to your project.
  - **Relative Imports**: All generated files use relative imports.
  - **Grouping**: Endpoints are grouped into services based on their Postman folder structure.


## Developed and Maintained by  
**[MIT PROGRAMMER LTD](https://mitprogrammer.com)**  

---

### Team  
**Lead Developer:** Muhammad Abbas 
🔗 [GitHub](https://github.com/Abbas355)  

**Flutter Developer:** Hamza Ashraf  
🔗 [GitHub](https://github.com/Hamzah660660)  

**Project Manager:** Mujahid Hussain  
🔗 [GitHub](https://github.com/MtechiTsolution)  

