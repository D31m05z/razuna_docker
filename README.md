# What is Razuna? ###

Razuna DAM is the open source alternative for Digital Asset Management Systems, it lets you centralize all your digital assets, automate and streamline your workflow, publish your assets directly to the web and collaborate with your team on all your assets.

### Manage digital assets of all formats
Razuna lets you manage and publish digital assets independently from any format. We support video, images, audio and many more file formats. Manage and access all your digital media assets in one location at any time.

Images, Videos and Audios can be individually converted to other formats within Razuna. This allows you to deliver the correct content to the right device on the fly. Pass on direct URLs to your customers and/or generate a public webpage with a collection of assets.

### Collaborate, access and share
Share any folder or collection with your group in a public space or within Razuna. With the commenting and discussion feature you can give appropriate feedback for each asset.

You can let users look at your assets with sharing a folder or collection. You can assign permissions to allow downloading of assets or enable the ordering (lightbox) option. You can even let them upload to your shared folder directly without the need for a login.

### Highly sophisticated search
With Razuna you cannot only store your digital assets but also search and find them again! Razuna does not only search the title or description of your documents, but does a full index search of the whole document. We even take it one step further and index available metadata within your assets.

### Cataloging made easy
Razuna integrates into your publishing workflow and captures, displays and writes metadata (XMP/ITPC/EXIF, etc.). This way you can add keywords and description that travel with your assets. It now also captures all metadata from different documents, videos and audio files.

To make information consistent across your media library Razuna uses the XMP standard. XMP is a open standard that is being used by all major vendors.


# Building process

`docker build -t "razuna:1.9.6" .`

# Running

`docker run --name razuna -p 8080:8080 razuna:1.9.6`
