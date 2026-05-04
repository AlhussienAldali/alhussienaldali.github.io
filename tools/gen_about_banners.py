#!/usr/bin/env python3
"""Write small theme-matched PNG banners (stdlib only) for About / Projects sections."""

from __future__ import annotations

import binascii
import struct
import zlib
from pathlib import Path

# Brand anchors (float 0..1): deep purple -> cyan / orange hints
DEEP = (26, 24, 48)
CYAN = (0, 229, 255)
ORANGE = (255, 77, 64)


def _lerp(a: float, b: float, t: float) -> float:
    return a + (b - a) * t


def _lerp3(
    c0: tuple[int, int, int], c1: tuple[int, int, int], t: float
) -> tuple[int, int, int]:
    return (
        int(_lerp(c0[0], c1[0], t)),
        int(_lerp(c0[1], c1[1], t)),
        int(_lerp(c0[2], c1[2], t)),
    )


def _chunk(chunk_type: bytes, data: bytes) -> bytes:
    crc = binascii.crc32(chunk_type + data) & 0xFFFFFFFF
    return struct.pack(">I", len(data)) + chunk_type + data + struct.pack(">I", crc)


def write_gradient_png(
    path: Path,
    width: int,
    height: int,
    hue_shift: float,
    *,
    vignette: float = 0.55,
) -> None:
    """RGBA horizontal gradient with slight vertical vignette; hue_shift twists cyan/orange mix."""
    raw = bytearray()
    for y in range(height):
        raw.append(0)  # filter: None
        vy = y / max(height - 1, 1)
        vmul = 1.0 - vignette * (1.0 - abs(vy - 0.5) * 2) ** 2
        for x in range(width):
            t = x / max(width - 1, 1)
            # phase shifts per section
            t2 = (t + hue_shift) % 1.0
            left = _lerp3(DEEP, CYAN, 0.35 + 0.45 * t2)
            right = _lerp3(DEEP, ORANGE, 0.25 + 0.55 * ((t2 + 0.35) % 1.0))
            mid = _lerp3(left, right, 0.5 + 0.5 * (t - 0.5))
            r, g, b = mid
            r = int(r * vmul)
            g = int(g * vmul)
            b = int(b * vmul)
            a = 255
            raw.extend((r, g, b, a))

    compressed = zlib.compress(bytes(raw), level=9)
    png = (
        b"\x89PNG\r\n\x1a\n"
        + _chunk(
            b"IHDR",
            struct.pack(
                ">IIBBBBB", width, height, 8, 6, 0, 0, 0
            ),  # 8-bit RGBA
        )
        + _chunk(b"IDAT", compressed)
        + _chunk(b"IEND", b"")
    )
    path.write_bytes(png)


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    out = root / "assets" / "images" / "about"
    out.mkdir(parents=True, exist_ok=True)

    banners = [
        ("about_intro.png", 0.02),
        ("about_stack.png", 0.12),
        ("about_focus.png", 0.22),
        ("about_experience.png", 0.32),
        ("about_education.png", 0.42),
        ("about_awards.png", 0.52),
        ("about_languages.png", 0.62),
    ]
    w, h = 960, 220
    for name, shift in banners:
        write_gradient_png(out / name, w, h, shift)

    proj = root / "assets" / "images" / "projects"
    proj.mkdir(parents=True, exist_ok=True)
    write_gradient_png(proj / "projects_header.png", w, h, 0.08)

    # Per-project tiles (subtle variety)
    for i, name in enumerate(
        [
            "project_humani.png",
            "project_siemens.png",
            "project_maids.png",
            "project_portfolio.png",
        ]
    ):
        write_gradient_png(proj / name, w, h, 0.15 + i * 0.11)

    print(f"Wrote banners to {out} and {proj}")


if __name__ == "__main__":
    main()
