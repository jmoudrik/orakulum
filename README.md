# Orákulum

## Q: Jak funguje web http://orakulum.j2m.cz?

Aby nebylo potřeba ručně editovat HTML soubory, web
používá jednoduchý statický [Zola engine](https://www.getzola.org/).
Ten používá [Markdown formát](https://www.markdownguide.org/basic-syntax/) pro editaci.
Web nemá (zatím) žádné CMS, změny udělané v tomto git repositáři se každou minutu 
jednoduše překlopí na server (pokud build stránky nezpůsobí žádné chyby).


## Q: Jak můžu editovat a vytvářet nové stránky s predikcemi?
- vytvořte si [účet na GitHubu](https://github.com/join), přihlašte se
- pošlete mi (josefmoudrik) svůj github nick, přidám vám práva na editaci tohoto repositáře
- potom můžete rovnou editovat & vytvářet nové markdown soubory ve složce
	[predikce](https://github.com/jmoudrik/orakulum/tree/master/site/content/predikce)
	- tam můžete třeba kliknout na **add file** pro přidání nového souboru
	- jako výchozí bod pro nové posty můžete použít obsah souboru [template](https://raw.githubusercontent.com/jmoudrik/orakulum/master/site/content/predikce/template.md), (zkopírujte jako obsah nového souboru).
- každou úpravu musíte dole na editační stránce Commitnout (~ uložit), je fajn
    při ukládání popsat (zhruba) změny v políčku Commit-message.
- úpravy se automaticky každých 5 minut překlopí na server


## Q: Co když má mnou vytvořený markdown chybu?

Na slacku je kanál `builds` kam bot automaticky hlásí všechny chyby na které narazí. Tzn, workflow je:
- Edit > Commit > kanál builds
	- pak buď hotovo, když build webu prošel
	- nebo znovu Edit, ... 
Jo, UX editovani je takhle trochu pain, zato je ale takhle celý web super jednoduchý a setup byl snadný.
Když to nebude vyhovovat, tak uděláme něco lepšího.


## Q: Jak rozběhat web u mne na počítači pro lokální editace?

### 1. Stáhnout závislosti

#### 1.1. Zola
- [návod na instalaci Zola enginu](https://www.getzola.org/documentation/getting-started/installation/)

#### 1.1. Git
- pro stažení repositáře je potřeba [mít nainstalovaný git](https://github.com/git-guides/install-git)

### 2. stáhnout tento repositář s webem

```
$ git clone https://github.com/jmoudrik/orakulum
```
### 3. spustit Zola engine
```
$ cd orakulum/site
$ zola serve
```

V prohlížeči nyní na adrese 127.0.0.1:1111 uvidíte celý web.
Nyní můžete editovat md soubory, např ve složce `content/predikce`,
úpravy se rovnou zobrazí v prohlížeči.

