PLATFORMS:=web linux windows
BUILD_DIR:=build
PROJECT_DIR:=godot
ITCH_USER:=petakitten
GAME_NAME:=godot-template
ITCH_PROJECT:=$(ITCH_USER)/$(GAME_NAME)
PROJECT_FILES:=$(shell find $(PROJECT_DIR) -name project.godot -o -name export_presets.cfg -o -name *.tscn -o -name *.scn -o -name *.tres -o -name *.res -printf '%p\n' | sed 's/ /\\ /g')

all: $(PLATFORMS:%=$(BUILD_DIR)/%.itch-upload)

zip: $(PLATFORMS:%=$(BUILD_DIR)/%.zip)

$(PLATFORMS:%=$(BUILD_DIR)/%):
	@mkdir -p $@

$(BUILD_DIR)/%.zip: $(PROJECT_FILES) | $(BUILD_DIR)/%
	godot --path $(PROJECT_DIR) --headless --export-debug $*
	cd $(@D) && zip $*.zip -r $*/

$(BUILD_DIR)/%.itch-upload: $(BUILD_DIR)/%.zip
	butler push $^ $(ITCH_PROJECT):$(strip $*)
	@touch $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all zip clean $(PLATFORMS:%=$(BUILD_DIR)/%)

