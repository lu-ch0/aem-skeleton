# AEM Local Instance

This repository provides a ready-to-use skeleton for setting up local AEM environments. It includes scripts to configure and run AEM Author and Publish instances in a clean and isolated directory structure.

## 🛠️ Cloning the Repo by OS and Minimal Download

This repository supports Linux/macOS and Windows scripts in separate branches to avoid downloading unnecessary files.

- **Linux/macOS users:** Clone the `main` branch which contains shell scripts and README with right instructions.
- **Windows users:** Clone the `windows` branch which contains batch scripts (experimental) and README with how to use.

To minimize download size, perform a shallow clone with only the latest commit:

### Linux/macOS

```bash
git clone --branch main --depth 1 https://github.com/lu-ch0/aem-skeleton.git your-instance-folder
cd your-instance-folder
```

### Windows (Git Bash)

```bash
git clone --branch windows --depth 1 https://github.com/lu-ch0/aem-skeleton.git your-instance-folder
cd your-instance-folder
```

## 📁 Folder Structure

```
.
├── init.sh               # Initializes the folder structure and copies the AEM JAR
├── run.sh                # Script to start/stop Author and/or Publish instances
├── author/               # Contains the Author jar
├── publish/              # Contains the Publish jar
├── logs/                 # Stores runtime logs and PIDs
├── dispatcher/           # Placeholder for dispatcher tools and configs
```

---

## ⚙️ Initial Setup

1. Download the AEM Quickstart jar from Adobe.
2. Run the `init.sh` script with the path to the downloaded jar:

```bash
./init.sh ~/Downloads/aem-sdk-2025.03.12345-quickstart.jar
```

This will:
- Create required folders
- Copy the JAR into both `author/` and `publish/` directories
- Delete the original JAR
- Remove `.git/` to make the setup standalone

---

## 🚀 Usage

### Start AEM

```bash
./run.sh start            # Starts only Author
./run.sh start author     # Starts only Author
./run.sh start publish    # Starts only Publish
./run.sh start both       # Starts both instances
```

### Stop AEM

```bash
./aem.sh stop           # Stop only Author
./aem.sh stop author
./aem.sh stop publish
./aem.sh stop both
```

Logs and PID files are saved under the `logs/` directory.

---

## 🧪 Simulating a Local AEM Runtime Distribution

To simulate a local runtime distribution as done in Adobe Cloud Service, follow Adobe's official instructions:

👉 [Simulate AEM Runtime Locally (Adobe Docs)](https://experienceleague.adobe.com/en/docs/experience-manager-learn/cloud-service/local-development-environment-set-up/aem-runtime#content-distribution)

---

## ✅ TODO

- [ ] Add local Dispatcher configuration templates under `dispatcher/`
- [ ] Include `run.sh` for Dispatcher simulation
- [ ] Add port configurability to `run.sh`
- [ ] Integrate support for `.env` configuration overrides
- [x] Add `status` command to check if instances are running

---

Feel free to fork this repo or use it as a template for each local AEM instance you need.