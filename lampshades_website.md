# Lampshade Adventures

**Published:** Jul 11, 2022  
**Tags:** 3D Printing, CAD, Lampshades, OpenSCAD, Selling, Learning

<img src="https://cdn.blot.im/blog_cb8d6372d4d34816883d8dfb5037f244/_image_cache/343826d1-dd50-49c3-89e5-2649972f082d.jpg" alt="A lamp" width="800" style="max-width:100%;height:auto;" />

A little while ago I went on a bit of a lampshade buzz. I designed and 3D printed a bunch of them and had a lot of fun. Then I tried to sell some lamps, which didn’t go as well as I wanted, but was a good learning experience. In this post, I will go over some of the key things I learnt designing, printing and trying to sell my lamps.

Also, if you want to print any of my designs yourself, you can! All the models are on [Printables](https://www.printables.com/social/308094-mjseabright/collections/207685) and the source files are on [GitHub](https://github.com/mjseabright/lampshades).

<img src="https://cdn.blot.im/blog_cb8d6372d4d34816883d8dfb5037f244/_image_cache/73dc8407-3e4c-4dad-be51-f9cbe1870154.jpg" alt="A lamp by my bed" width="800" style="max-width:100%;height:auto;" />

I set up all the lamps beside my bed for marketing shots.

## Selling Things Online Can Be Hard

Once I’d designed a bunch of lamps, I decided to put them on Etsy and Felt (the local New Zealand version of Etsy) to try to sell them. I took a bunch of pictures and spent time thinking of names and descriptions for each of the designs. Once I put them all up for sale, not much really happened.

I sold two of them on Etsy, both to friends of mine, but that’s it. As I write this, they have been for sale for about two and a half months and there have been just the two sales. Admittedly, I have done no advertising (because I refuse to use Instagram or Facebook or any of that).

It may have been a bit naive of me to think that just being on Etsy is enough to sell something. Overall, I’m ok with not selling them as I don’t really want to spend my time manufacturing lamps for money.

## You Have To Put Yourself Out There

After debating whether I should or not, I went to the local Saturday market and showed the lamps off. It was great to see people’s reaction to them. A lot of people commented that they thought they were really cool. I had some good conversations with people about how I made them. I also sold two lamps to people I’d never met before.

Overall, I lost money as it cost to have a stall there. But being able to get the lamps in front of people was well worth it. I didn’t put a lot of effort into the stall; it was just a table with a bunch of lamps on it and a sign. If I go again, I think it would be cool to have the printer there printing. I also think it would be cool to have a lot more lamps there.

I’m really glad I went to the market. It was fun and I made my first sales to people I don’t know.

<img src="https://cdn.blot.im/blog_cb8d6372d4d34816883d8dfb5037f244/_image_cache/1fc82ee6-09e2-47f1-b11c-f42e480b8c3c.jpg" alt="Me at the markets" width="800" style="max-width:100%;height:auto;" />

Me at the markets. I even wore a pineapple shirt to go with one of my designs.

## PLA Doesn’t Like Heat

I’ve previously had a part printed from PLA warp from being in the sun. So I decided to test how a lampshade would go. I printed two lampshades, one from PLA and one from PETG, and put them on the dashboard of my car for a day.

You can see for yourself how that went below. This is a shame as I didn’t want to sell lamps that would turn to a puddle if left beside a window on a hot day, so I had to print in PETG. However, there is a far more limited range of filament colours available in PETG and the prints don’t look quite as nice.

<img src="https://cdn.blot.im/blog_cb8d6372d4d34816883d8dfb5037f244/_image_cache/85e2f51b-f648-4f28-9e8a-8e70ecaecd6c.jpg" alt="PLA lampshade collapsed" width="800" style="max-width:100%;height:auto;" />

## Experiment More With Print Settings

When designing multiple lampshades in an evening but each one taking up to 10 hours to print, I quickly got tired of waiting. I messed around trying to find the best settings to get high quality prints in minimal time. It turned out there was a lot of time to be saved (about half) by running the printer a bit faster than the default settings. Print quality didn’t seem to suffer much at all.

I was much happier being able to print a handful of new designs in a day rather than just one or two.

All of my designs are printed in vase mode (single wall), so I also experimented with the extrusion width to see what looked best and made for a sturdy enough lampshade. This is something I’ve never tried before, but I really liked the result and will keep in mind for future models.

<img src="https://cdn.blot.im/blog_cb8d6372d4d34816883d8dfb5037f244/_image_cache/8df9bd71-0872-4c62-9fa0-7c582b3242d5.jpg" alt="One of my favorite designs" width="800" style="max-width:100%;height:auto;" />

This is one of my favorite designs.

## OpenSCAD Is Really Cool, And Can Be Quick

I’ve used OpenSCAD a few times in the past and it’s always seemed like a cool tool. But doing this project, I was able to make much better use of OpenSCAD than I had in the past.

A few things that helped me speed up OpenSCAD:

- Do as many operations (unions/intersections etc.) in 2D as possible before extruding to 3D.
- If your part is made from a number of intersecting (or touching) solids, you don’t necessarily have to union them at the end. My lampshades were generally made up of lots of 0.2 mm thick layers stacked on top of each other. A final union to turn it into one continuous mesh is really slow. But the slicer doesn’t care if it’s many meshes or just one. So I stopped bothering to union and saved a lot of rendering time.
- Lowering quality while messing around with the design saved me a lot of time. I did this by using `$fn` and `$fa` arguments for circles and spheres (making them more/less faceted). I also used larger layer heights, which gives a coarser design but can be much faster. When I was happy with the design, I’d change back to finer settings and render.
- The `fast-csg` settings discussed [here](https://ochafik.com/jekyll/update/2022/02/09/openscad-fast-csg-contibution.html) sped up rendering for me from hours to minutes on some designs.

## I Like Pretty Colourful Lights

The thing I enjoyed most about the whole process was always the moment of turning the lamp on and seeing a new design shine. Often when I took a new design off the printer I would hate it. I’d be a bit annoyed that I’d spent hours designing it for it to come out so ugly. Then I’d put it on a lamp base and turn it on and realise that it’s not ugly at all—it looks amazing!

I think I’m initially biased towards seeing the flaws in the things I create and that just leads to unhappiness. I love the lamps I’ve designed and I’m happy every time I turn one on. And that’s all I really want from any project I take on.

<img src="https://cdn.blot.im/blog_cb8d6372d4d34816883d8dfb5037f244/_image_cache/d33b56ed-9e58-4f8e-96c4-633b387bc61f.jpg" alt="Another cool lamp" width="800" style="max-width:100%;height:auto;" />

This is another one I like.
