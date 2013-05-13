package juice.objects.topdown {
    import flash.geom.Rectangle;
    
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionType;
    import nape.callbacks.PreCallback;
    import nape.callbacks.PreFlag;
    import nape.callbacks.PreListener;
    import nape.geom.Vec2;
    import nape.phys.BodyType;
    
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    import citrus.objects.NapePhysicsObject;
    import citrus.view.starlingview.AnimationSequence;
    
    import juice.utils.AssetManager;
    
    public class Player extends Entity {
        public function Player(name:String, params:Object = null) {
            super(name, params);
        }
        
        override public function init(assets:AssetManager):void {
            var texture:Texture;
            
            if(this.kind.id === 210) {
                texture = assets.getTexture("tiles/blue");    
            }
            else if(this.kind.id === 202) {
                texture = assets.getTexture("tiles/red");
            }
            
            var atlas:TextureAtlas = new TextureAtlas(texture);
            for each(var region:String in ['fire', 'stand', 'walk', 'hurt', 'attack', 'idle', 'jump', 'die', 'duck']) {
                atlas.addRegion(region, new Rectangle(0, 0, 18, 18));
            }
            
            var view:AnimationSequence = new AnimationSequence(atlas, ["fire", "stand", "walk", 'hurt', 'attack', 'idle', 'jump', 'die', 'duck'], "idle", 30, true);
            
            this.view = view;
        }
    }
}