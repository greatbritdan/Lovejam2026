return {
    default = {
        font = Font,
        marginx = 0, marginy = 0,
        styles = {
            base = {image="assets/ui/base.png", cornersize=6},
            backbase = {color={
                {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}},
                {{0,0,0,.65},{0,0,0,.65},{0,0,0,.65},{0,0,0,.65}}
            }, cornersize=8},
            text = {color={{{1,1,1},{1,1,1},{1,1,1},{.5,.5,.5,.25}}}},
            image = {color={{{1,1,1},{1,1,1},{1,1,1},{.5,.5,.5,.25}}}},
        }
    },
    slider = {
        styles = {
            base = {image="assets/ui/sliderbase.png", cornersize=6},
            bulb = {image="assets/ui/base.png", cornersize=6},
        }
    },
    input = {
        styles = {
            base = {image="assets/ui/inputbase.png", cornersize=6},
        }
    }
}