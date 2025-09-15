import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';

@Injectable()
export class PostsService {
  constructor(private prisma: PrismaService) {}

  async create(createPostDto: CreatePostDto) {
    const { title, content, published, authorId } = createPostDto;

    // Check if author exists
    const author = await this.prisma.user.findUnique({
      where: { id: authorId },
    });

    if (!author) {
      throw new NotFoundException(`Author with ID ${authorId} not found`);
    }

    const post = await this.prisma.post.create({
      data: {
        title,
        content,
        published: published || false,
        authorId,
      },
      include: {
        author: {
          select: {
            id: true,
            email: true,
            name: true,
            isActive: true,
            createdAt: true,
            updatedAt: true,
          },
        },
      },
    });

    return post;
  }

  async findAll() {
    const posts = await this.prisma.post.findMany({
      include: {
        author: {
          select: {
            id: true,
            email: true,
            name: true,
            isActive: true,
            createdAt: true,
            updatedAt: true,
          },
        },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    return posts;
  }

  async findOne(id: number) {
    const post = await this.prisma.post.findUnique({
      where: { id },
      include: {
        author: {
          select: {
            id: true,
            email: true,
            name: true,
            isActive: true,
            createdAt: true,
            updatedAt: true,
          },
        },
      },
    });

    if (!post) {
      throw new NotFoundException(`Post with ID ${id} not found`);
    }

    return post;
  }

  async update(id: number, updatePostDto: UpdatePostDto) {
    const { title, content, published, authorId } = updatePostDto;

    // Check if post exists
    const existingPost = await this.prisma.post.findUnique({
      where: { id },
    });

    if (!existingPost) {
      throw new NotFoundException(`Post with ID ${id} not found`);
    }

    // Check if author exists (if authorId is being updated)
    if (authorId && authorId !== existingPost.authorId) {
      const author = await this.prisma.user.findUnique({
        where: { id: authorId },
      });

      if (!author) {
        throw new NotFoundException(`Author with ID ${authorId} not found`);
      }
    }

    const post = await this.prisma.post.update({
      where: { id },
      data: {
        ...(title && { title }),
        ...(content !== undefined && { content }),
        ...(published !== undefined && { published }),
        ...(authorId && { authorId }),
      },
      include: {
        author: {
          select: {
            id: true,
            email: true,
            name: true,
            isActive: true,
            createdAt: true,
            updatedAt: true,
          },
        },
      },
    });

    return post;
  }

  async remove(id: number) {
    const post = await this.prisma.post.findUnique({
      where: { id },
    });

    if (!post) {
      throw new NotFoundException(`Post with ID ${id} not found`);
    }

    await this.prisma.post.delete({
      where: { id },
    });

    return { message: 'Post deleted successfully' };
  }
}
