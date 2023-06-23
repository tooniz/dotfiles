#!/usr/bin/env python3

import torch

from torch import Tensor
from timeit import default_timer as timer

# Tilizer that reblocks a 3D tensor and tilizes in headerless tiles
def block_tensor(tensor: Tensor, blocks_r: int, blocks_c: int, ublocks_r: int, ublocks_c: int,
                 tiles_r: int, tiles_c: int, faces_r: int, faces_c: int, face_dim: int) -> Tensor:
    batch = tensor.shape[-3]
    blocked_tensor = tensor.reshape(batch, blocks_r,ublocks_r,tiles_r,faces_r,face_dim,blocks_c,ublocks_c,tiles_c,faces_c,face_dim)
    permuted = blocked_tensor.permute(-11,-10,-5,-9,-4,-8,-3,-7,-2,-6,-1)
    flattened = permuted.flatten(start_dim=-11,end_dim=-1)
    back_3d = flattened.reshape(tensor.shape[-3], tensor.shape[-2], tensor.shape[-1])
    return back_3d

def align_up(value, align):
    return (value + align - 1) & ~(align - 1)

def main():
    # resnet50 shapes
    microbatch_size = 256
    shape = [microbatch_size, 112*112, align_up(3*49, 32)]

    # grid dim
    blocks_r, blocks_c = 7, 1

    # mblock dim
    ublocks_r, ublocks_c = 14, 1

    # ublock dim
    tiles_r, tiles_c = 4, 5

    # tile dim
    tile_dim = 32
    face_dim = 16
    faces_r = int(tile_dim / face_dim)
    faces_c = int(tile_dim / face_dim)

    assert shape[-2] == blocks_r * ublocks_r * tiles_r * tile_dim
    assert shape[-1] == blocks_c * ublocks_c * tiles_c * tile_dim

    # 8-bit format tensor
    tensor = torch.ones(shape, dtype=torch.int8)
    nbytes = tensor.nelement() * tensor.element_size()

    start = timer()
    blocked = block_tensor(tensor, blocks_r, blocks_c, ublocks_r, ublocks_c, tiles_r, tiles_c, faces_r, faces_c, face_dim)
    duration = timer() - start
    print(f"PERF: Int8 tilize time = {duration:.2f}, {microbatch_size/(duration):.2f} samples/s, {nbytes/(duration*1024**3):.2f} GB/s")

    # 16-bit format tensor
    tensor = torch.ones(shape, dtype=torch.float16)
    nbytes = tensor.nelement() * tensor.element_size()

    start = timer()
    blocked = block_tensor(tensor, blocks_r, blocks_c, ublocks_r, ublocks_c, tiles_r, tiles_c, faces_r, faces_c, face_dim)
    duration = timer() - start
    print(f"PERF: Float16 tilize time = {duration:.2f}, {microbatch_size/(duration):.2f} samples/s, {nbytes/(duration*1024**3):.2f} GB/s")

if __name__ == "__main__":
    main()
