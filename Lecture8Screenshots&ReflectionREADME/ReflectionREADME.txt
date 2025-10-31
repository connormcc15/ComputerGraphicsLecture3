NOTE: Screenshots are not inside readme. They should be outside of this readme.

1. StandardSpecular and StandardPBR + Transparency
I created the standard specular and standard pbr shaders and then made the metallic texture.
It took me a while for me to notice the difference between the two but eventually I finally got then to look good.
This shader would be good for anything metal or something that you want to have a metallic look.
For the transparency i got a tree png form the internet and applied into the scene.
This can be used for optimizing the performace of your game for that there is not so many assets slowing down the flow of the game.

2. Hologram
I created the hologram shader and applied it to a golem model and a primative capsule.
I started to play around with the parameters of the hologram. I found that the rim intensity can allow for a character for a death animation to satrt glowing and then have the explosion over the character and then just simply deactivate the character from the scene.
I also found that the line direction can be inversed by changing the '+' to a '-' in the lineValue section in fragment.
Holograms can be used for communication between characters and also have an item have just a holographic outline becuase it might not be unlocked yet.

3. Texture Blending and Decal
For the texture blending, I created the shader however when I applied it to a quad, I wasn't sure if I made it correctly. I believe I might have missed a step or two when making the texture blending. For the decal though, This worked fine. I created it and applied it to another golem model. I noticed that the decal when toggled on, does not replace the other texture but rather goes overtop of it and blends together. This can be used for battle damage for a character. An example would be the Marvel Spider Man Games as when Spider Man takes damage, the suit he is wearing will take a more battle damaged look.

4. Stencil
For the Stencil, I created both the front object and the hole object shaders respectively. I then applied the front to a sphere and the hole to a cube. I noticed that when overtop one another, the cube became almost hollow in a way, however at certain angles, the cube started to reappear. This can be used for a way to see through walls in a game.

Overall, I feel like I am getting better at making the shader, applying it and then thinking of ways to apply them in my game sor games in general.
