#!/usr/bin/env python3
#
import random
from locust import HttpUser, task, between

# obtained via https://random-word-api.herokuapp.com/word?number=200
words = ["sacraria","seedcake","philtered","leadiest","cloverleafs","snaffle","lyrisms","ankhs","bedtimes","carrier","restabling","playlets","occupation","overreport","printers","scintigraphic","spa","corsages","enwound","gossipmonger","hydragog","waterlily","avulsions","sonneteerings","spilt","hemocytes","tamandus","rais","minaret","coliseums","ultramicrotome","attribute","phosphite","scincoids","scooting","frightfulnesses","carbamides","sculpture","irresponsive","overtasks","expertise","weet","consociations","tulles","hared","pigginesses","oversimple","theologs","adverb","inamoratas","teeny","rapacities","assonant","metestrus","cyanohydrin","smiting","polychete","merest","tautological","phyllopod","petahertz","plainspokenness","pavior","penitently","omikrons","cigarlike","foetal","diebacks","downlight","kinship","warmish","titleholders","suppositions","resuscitations","tiffing","outsung","homed","alternated","cranks","piaster","allotters","nonirradiated","protohistories","finned","decouple","shahs","foeman","perfidious","soarers","thoroughpins","gastrulating","thrivers","convention","roughened","uncircumcised","clabbering","leadscrew","panfuls","nilgais","evolver","overvoting","furrower","ichthyosaurs","internalizes","borschts","regrouping","lordlier","roguish","microseismicity","besmiling","mattoids","cholerically","fibrosarcomas","farinha","curricles","triradiate","beringed","electrolysis","kashmirs","dirdums","ignorami","otalgic","lusciously","blotty","pizzaz","educe","pendant","disposable","autolyzes","outjutting","interfused","operagoers","fustian","theretofore","dean","unsullied","goitrogenic","ultrasafe","potboil","geochemistries","outdesigned","ephedras","woodlore","illuminatingly","guardrooms","sheldrakes","leachable","theistically","reconception","beachboys","recriminates","almuds","changeabilities","flareups","machinate","verbalizations","dendrologist","unkept","copulatives","restyles","parceled","caecilians","mortgager","thunderstones","labarums","wiliness","hydroplane","already","unlatch","swineherds","alternate","whodunit","hoodiest","sainted","detract","inspiring","fantastically","macaws","adsorbs","thickets","blogs","greenfields","ariettes","camphor","hornpipe","uninventive","boatyard","boomiest","lollingly","congresspersons","painter","radiocarbons","impiously","unfeigned","matchlocks","screwballs","stickies","muddlers","resentful","meats"]

class OcamlOrgUsere(HttpUser):
    wait_time = between(1, 5) # range of seconds a user waits between clicks

    @task
    def landing(self):
        self.client.get("/")
        self.client.get("/install")
        self.client.get("/p/core/latest/doc/index.html")
        self.client.get("/docs/tour-of-ocaml")

    @task
    def top_level_pages(self):
        self.client.get("/docs")
        self.client.get("/platform")
        self.client.get("/packages")
        self.client.get("/community")
        self.client.get("/changelog")
        self.client.get("/play")
        self.client.get("/industrial-users")
        self.client.get("/academic-users")

    @task
    def package_searches(self):
        query = random.choice(words)
        self.client.get(f"/packages/autocomplete?q={query}")
        self.client.get(f"/packages/search?q={query}")
