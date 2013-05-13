package tileworld.ui.editor.settings {
    
    import feathers.controls.Button;
    
    import tileworld.core.World;
    import tileworld.objects.Entity;
    
    public class ManageEntitySettings {
        public var world:World;
        public var isSelectable:Boolean = true;
        public var hasElasticEdges:Boolean = true;
        public var entity:Entity;
        
        public function ManageEntitySettings(world:World, entity:Entity):void {
            this.world = world;
            this.entity = entity;
        }
    }
}