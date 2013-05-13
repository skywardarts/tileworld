package juice.objects.topdown {
    import citrus.objects.NapePhysicsObject;
    import citrus.view.starlingview.AnimationSequence;
    
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    
    import nape.callbacks.CbType;
    import nape.callbacks.InteractionType;
    import nape.callbacks.PreCallback;
    import nape.callbacks.PreFlag;
    import nape.callbacks.PreListener;
    import nape.geom.Vec2;
    import nape.phys.BodyType;
    
    import org.osflash.signals.Signal;
    
    import starling.display.Image;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    import juice.core.Kind;
    import juice.utils.AssetManager;
    
    public class Entity extends NapePhysicsObject {
        public var id:int;
        public var kind:Kind;
        
        public function Entity(name:String, params:Object = null):void {
            this.kind = new Kind();
            
            super(name, params);
            
            this.body.allowRotation = false;
        }
        
        override public function update(timeDelta:Number):void {
            super.update(timeDelta);
        }
        
        override protected function defineBody():void {
            _bodyType = BodyType.DYNAMIC;
        }
        
        override protected function createMaterial():void {
            super.createMaterial();
            
            _material.elasticity = 0;
        }
        
        public function init(assets:AssetManager):void {
            var view:Image;
            
            var shape:Object = {
                id: 1,
                width: 2,
                height: 3,
                data: [
                    1, 0,
                    1, 0,
                    1, 1
                ]
            };
            
            var resources:Object = {
                208: 'tiles/red',
                209: 'tiles/blue',
                210: 'tiles/blocked',
                211: 'tiles/blocked',
                212: 'tiles/blocked'
            };
                
                
            var resourceName:String = resources[this.kind.id] ? resources[this.kind.id] : 'tiles/blocked';
            
            var tex:Texture;
        
            var bitmap:Bitmap = assets.getBitmap(resourceName);
            
            tex = Texture.fromBitmap(bitmap);
            
            view = new Image(tex);
            
            this.view = view;
        }
        /*
        this.entityId = opts.entityId;
        this.kindId = opts.kindId;
        this.kindName = opts.kindName;
        this.englishName = opts.englishName;
        this.type = opts.type;
        
        //position
        this.x = opts.x;
        this.y = opts.y;
        
        //global object 
        this.scene = opts.scene;
        this.map = opts.map;
        
        this.sprite = new Sprite(this);*/
    }
}