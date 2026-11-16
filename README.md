# ACE-Step 1.5 – Filename Prefix + Models in JSON

A small patch for the Gradio UI of [ACE-Step 1.5](https://github.com/ace-step/ACE-Step-1.5) that makes the saved songs easier to find and to recreate.

🇮🇹 [Versione italiana più sotto](#italiano)

This is an **unofficial** community patch. It is not affiliated with or endorsed by the ACE-Step team.

## What it does

| Without the patch | With the patch |
|---|---|
| Files are saved as `<random>.mp3` / `<random>.json` | A **File name prefix** field above the Generate button: files become `<prefix>_<random>.mp3` / `.json` (empty field = random name only, as before) |
| The JSON does not say which models made the song | The JSON also stores `filename_prefix`, `dit_model`, `lm_model` and `vae_checkpoint` |
| Loading a JSON restores the parameters only | Loading a new-format JSON also sets the prefix and the DiT / LM / VAE dropdowns |

Details:

- Characters that are not valid in file names (`<>:"/\|?*`) and spaces become `_`. The prefix is cut to 80 characters.
- `lm_model` is `null` when the LM is not initialized.
- If the loaded JSON uses models different from the ones currently loaded, a warning asks you to press **Initialize Service** before generating. The dropdowns are already set; the models are not reloaded automatically.
- A model from the JSON that is not in your `checkpoints` folder is not selected, and a warning tells you which one is missing.
- **Old JSON files** (without these keys) still load as before: prefix and models are left unchanged.
- Background batches (AutoGen) use the same prefix.

## Install

1. Download this repository (green **Code** button → **Download ZIP**) and extract it.
2. Put the extracted folder **inside** your `ACE-Step-1.5` folder, next to `start_gradio_ui.bat`.
3. Double-click `apply_patch.bat`.
4. Restart the Gradio UI.

The script uses the bundled `PortableGit` of the Windows portable package if present, otherwise `git` from `PATH`. It does not change your git configuration.

Linux / macOS, or by hand, from the `ACE-Step-1.5` folder:

```bash
git apply path/to/patches/filename_prefix_and_models.patch
```

## Updating ACE-Step

`git pull` refuses to update files that you changed. So:

1. `remove_patch.bat` (restores the original files)
2. update ACE-Step as usual (`check_update.bat` or `git pull`)
3. `apply_patch.bat`

`apply_patch.bat` skips patches that are already applied. If the patch no longer applies cleanly, it tries `git apply --3way`.

Linux / macOS: `git apply -R <patch>` before updating, `git apply <patch>` after.

## Files changed

- `acestep/ui/gradio/events/results/filename_prefix.py` (new)
- `acestep/ui/gradio/events/results/generation_progress.py`
- `acestep/ui/gradio/events/wiring/generation_run_wiring.py`
- `acestep/ui/gradio/events/wiring/generation_metadata_file_wiring.py`
- `acestep/ui/gradio/interfaces/generation_tab_generate_controls.py`

Every changed line is marked with `[local patch]`.

Made against ACE-Step-1.5 commit [`14c0211`](https://github.com/ace-step/ACE-Step-1.5/commit/14c0211d5a0653b0f63e27686f4c3f151b4d8629).

## Troubleshooting

**"ERROR: upstream code changed too much"** – ACE-Step changed the same lines that the patch changes. Open an issue in this repository with the ACE-Step commit you are on (`git log -1`).

**"already applied, skipped"** after an update – the patch is still in place; nothing to do.

**"not applied (or files edited by hand), skipped"** in `remove_patch.bat` – the files are not the ones the patch expects. Run `git status` in the `ACE-Step-1.5` folder to see which ones changed.

## License

MIT. ACE-Step 1.5 is © ACEStep, MIT license.

---

<a id="italiano"></a>

## 🇮🇹 Italiano

Patch non ufficiale per l'interfaccia Gradio di ACE-Step 1.5.

**Cosa fa**

- Campo **Prefisso file / File name prefix** sopra il pulsante Genera: i file diventano `<prefisso>_<stringa random>.mp3/.json`. Campo vuoto = solo stringa random, come prima. Spazi e caratteri non validi diventano `_`.
- Il JSON salva anche `filename_prefix`, `dit_model`, `lm_model` (`null` se l'LM non è inizializzato) e `vae_checkpoint`.
- Caricando un JSON nuovo formato vengono impostati il prefisso e i menu dei modelli DiT / LM / VAE. Se sono diversi da quelli caricati compare un avviso: premere **Initialize Service** prima di generare.
- I **JSON vecchi** (senza queste chiavi) si caricano come prima: prefisso e modelli restano invariati.

**Installazione**

1. Scarica il repository (**Code** → **Download ZIP**) ed estrailo.
2. Metti la cartella estratta **dentro** `ACE-Step-1.5`, accanto a `start_gradio_ui.bat`.
3. Doppio click su `apply_patch.bat`.
4. Riavvia l'interfaccia.

**Aggiornare ACE-Step**

1. `remove_patch.bat` (ripristina i file originali, così `git pull` non trova conflitti)
2. aggiorna ACE-Step (`check_update.bat` o `git pull`)
3. `apply_patch.bat`

Se `apply_patch.bat` segnala ERRORE, ACE-Step ha cambiato le stesse righe della patch: apri una issue con il commit di ACE-Step che stai usando.
