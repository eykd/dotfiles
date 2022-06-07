#!/usr/bin/env python
import itertools as it
import tempfile

import click
from path import Path
from sh import convert, grep, identify, primitive


@click.command()
@click.argument('src')
@click.argument('dest')
@click.option('--shapes', default=250, help='Number of shapes to output per frame')
@click.option('--mode', default=1, help='0=combo, 1=triangle, 2=rect, 3=ellipse, 4=circle, 5=rotatedrect, 6=beziers, 7=rotatedellipse, 8=polygon')
def main(src, dest, shapes, mode):
    """Process a GIF with Primitive"""
    src = Path(src).expanduser().abspath()
    dest = Path(dest).expanduser().abspath()

    with tempfile.TemporaryDirectory() as tmp_d:
        tmp_d = Path(tmp_d)
        source_pngs = tmp_d / 'source'
        processed_pngs = tmp_d / 'processed'
        source_pngs.makedirs_p()
        processed_pngs.makedirs_p()

        frame_delays = [
            line.split()[-1]
            for line in grep(identify('-verbose', src), 'Delay').splitlines()
        ]

        click.echo('Coalescing animation frames...')
        convert('-coalesce', src, source_pngs / 'src%09d.png')
        frames = []
        sources = source_pngs.listdir('*.png')
        click.echo(f'Primitivizing {len(sources)} frames.')
        for png_src in source_pngs.listdir('*.png'):
            png_dest = processed_pngs / png_src.name
            frames.append(png_dest)
            click.echo(f'Primitivizing {png_src.name}...')
            primitive(i=png_src, o=png_dest, n=shapes, m=mode)

        delay_length_frame = it.chain(*zip(it.repeat('-delay'), frame_delays, frames))

        click.echo('Building new animation...')
        convert('-layers', 'optimize', '-loop', 0, *delay_length_frame, dest)


if __name__ == '__main__':
    main()
