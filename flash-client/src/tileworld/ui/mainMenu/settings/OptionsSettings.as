package tileworld.ui.mainMenu.settings {
    import feathers.controls.Button;
    
    import tileworld.core.World;
    
    public class OptionsSettings {
        public var world:World;
        public var isSelectable:Boolean = true;
        public var hasElasticEdges:Boolean = true;
        
        public function OptionsSettings(world:World):void {
            this.world = world;
        }
    }
}